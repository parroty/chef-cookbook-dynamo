#
# Cookbook Name:: dynamo
# Attributes:: default
#

default[:dynamo][:source][:repo] = "https://github.com/parroty/dynamo_sample.git"
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
