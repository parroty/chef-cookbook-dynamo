#
# Cookbook Name:: dynamo
# Recipe:: source
#

log "start of dynamo::source recipe" do
  level :debug
end

cache_path = Chef::Config[:file_cache_path]
rebar_download_path = "#{cache_path}/rebar"

include_recipe "git"

# install rebar
git "rebar" do
  repository "https://github.com/rebar/rebar"
  destination rebar_download_path
  action :sync
end

bash "rebar install" do
  cwd rebar_download_path
  code <<-EOH
    make
    cp ./rebar #{node[:dynamo][:rebar][:install_path]}/rebar
    EOH
  action :nothing
  subscribes :run, "git[rebar]", :immediately
end

# install foreman
package "ruby"
gem_package "foreman"

# prepare database
if node[:dynamo][:flags][:use_ecto]
  include_recipe "build-essential"

  # create database and user
  db_user     = node[:dynamo][:ecto][:database_user]
  db_name     = node[:dynamo][:ecto][:database_name]
  db_password = node[:dynamo][:ecto][:database_password]

  node.default[:postgresql][:password][:postgres] = node[:dynamo][:ecto][:database_password]
  include_recipe "postgresql::server"

  execute "create root user" do
    user "postgres"
    command "createuser -U postgres -s root"
    not_if "psql -U postgres -c \"select * from pg_user where usename='root'\" | grep -c root", :user => "postgres"
  end

  execute "create database user" do
    user "postgres"
    command "createuser -U postgres -sw #{db_user}"
    not_if "psql -U postgres -c \"select * from pg_user where usename='#{db_user}'\" | grep -c #{db_user}", :user => "postgres"
  end

  execute "create database" do
    user "postgres"
    command "createdb -U postgres -O #{db_user} -E utf8 -T template0 #{db_name}"
    not_if "psql -U postgres -c \"select * from pg_database WHERE datname='#{db_name}'\" | grep -c #{db_name}", :user => "postgres"
  end
end

# create a user for dynamo
user node[:dynamo][:service][:user] do
  shell "/bin/bash"
end

# prepare dynamo application
git "dynamo" do
  repository node[:dynamo][:source][:repo]
  destination node[:dynamo][:install_path]
  action :sync
end

directory node[:dynamo][:install_path] do
  mode 00755
end

bash "prepare dynamo" do
  cwd node[:dynamo][:install_path]
  code "mix deps.get"
  action :nothing
  subscribes :run, "git[dynamo]", :immediately
end

# perform migration
if node[:dynamo][:flags][:perform_migration]
  bash "perform db migration" do
    cwd node[:dynamo][:install_path]
    code "mix ecto.migrate #{node[:dynamo][:ecto][:repo_name]}"
    action :run
  end
end

# start dynamo application
bash "ensure to change owner to service user" do
  code <<-EOH
  chown -R #{node[:dynamo][:service][:user]} #{node[:dynamo][:install_path]}
  chgrp -R #{node[:dynamo][:service][:user]} #{node[:dynamo][:install_path]}
  EOH
  action :run
  not_if "stat -c %U #{node[:dynamo][:install_path]} | grep #{node[:dynamo][:service][:user]}"
end

bash "start dynamo" do
  cwd node[:dynamo][:install_path]
  code <<-EOH
    echo 'web: mix server -p #{node[:dynamo][:service][:port]}' > Procfile
    foreman export --app #{node[:dynamo][:service][:name]} --user #{node[:dynamo][:service][:user]} upstart /etc/init
    EOH
  action :run
  not_if { ::File.exists?("#{node[:dynamo][:install_path]}/Procfile") }
end

service node[:dynamo][:service][:name] do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => false
  action [ :enable, :start ]
end

log "end of dynamo::source recipe" do
  level :debug
end
