#
# Cookbook Name:: dynamo
# Recipe:: source
#

cache_path = Chef::Config[:file_cache_path]
rebar_download_path = "#{cache_path}/rebar"

include_recipe "git"

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

package "ruby"
gem_package "foreman"

git "dynamo" do
  repository node[:dynamo][:source][:repo]
  destination node[:dynamo][:install_path]

  action :sync
end

bash "prepare dynamo" do
  cwd node[:dynamo][:install_path]
  code "mix deps.get"

  action :run
end

bash "setup dynamo" do
  cwd node[:dynamo][:install_path]
  code <<-EOH
    echo 'web: mix server -p #{node[:dynamo][:service][:port]}' > Procfile
    foreman export --app #{node[:dynamo][:service][:name]} --user #{node[:dynamo][:service][:user]} upstart /etc/init
    EOH
  action :run
end

service node[:dynamo][:service][:name] do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
