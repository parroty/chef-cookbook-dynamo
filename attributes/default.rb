#
# Cookbook Name:: dynamo
# Attributes:: default
#

default[:dynamo][:source][:repo] = "https://github.com/parroty/dynamo_sample.git"
default[:dynamo][:source][:revision] = "master"

default[:dynamo][:install_path] = "/usr/local/lib/dynamo"
default[:dynamo][:service][:name] = "dynamo"
default[:dynamo][:service][:user] = "dynamo"
default[:dynamo][:service][:port] = 4000

default[:dynamo][:flags][:use_ecto] = false
default[:dynamo][:flags][:perform_migration] = false

default[:dynamo][:ecto][:repo_name] = "Repo"
default[:dynamo][:ecto][:database_name] = "ecto_simple"
default[:dynamo][:ecto][:database_user] = "postgres"
default[:dynamo][:ecto][:database_password] = "postgres"

default[:dynamo][:rebar][:install_path] = "/usr/local/bin"

default[:dynamo][:postgresql][:enable_pgdg_yum] = true
default[:dynamo][:postgresql][:version] = "9.2"
default[:dynamo][:postgresql][:dir] = "/var/lib/pgsql/9.2/data"
default[:dynamo][:postgresql][:client][:packages] = ["postgresql92", "postgresql92-devel"]
default[:dynamo][:postgresql][:server][:packages] = ["postgresql92-server"]
default[:dynamo][:postgresql][:server][:service_name] = "postgresql-9.2"
default[:dynamo][:postgresql][:contrib][:packages] = ["postgresql92-contrib"]
