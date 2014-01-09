#
# Cookbook Name:: dynamo
# Attributes:: default
#

default[:dynamo][:source][:repo] = "https://github.com/parroty/dynamo_sample.git"

default[:dynamo][:install_path] = "/usr/local/lib/dynamo"
default[:dynamo][:service][:name] = "dynamo_service"
default[:dynamo][:service][:user] = "root"
default[:dynamo][:service][:port] = 8080

default[:dynamo][:rebar][:install_path] = "/usr/local/bin"