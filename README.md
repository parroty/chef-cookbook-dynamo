Description
===========

Manages installation of Dynamo via packages or source.
This cookbook performs the following.
- Download dynamo application from git server.
- Registers dynamo application to upstart service for starting/stopping.

Requirements
============

## Chef

Tested on Chef 11.8.2.

## Platform

Tested on:

* Ubuntu 13.04

**Notes**: This cookbook has been tested on the listed platforms, but not with the all combinations of parameters. It may work on other platforms with or without modification.

## Cookbooks

* elixir (https://github.com/parroty/chef-cookbook-elixir)

### Berksfile
As an example, the following berksfile would work.

```ruby
site :opscode

cookbook 'git'
cookbook 'erlang', git: 'https://github.com/opscode-cookbooks/erlang.git'
cookbook 'elixir', git: 'git://github.com/parroty/chef-cookbook-elixir.git'
cookbook 'dynamo', git: 'git://github.com/parroty/chef-cookbook-dynamo.git'
```

## Ruby
It uses ruby and foreman to starting/stopping application.

Attributes
==========
By default, it downloads dynamo sample application files (https://github.com/parroty/dynamo_sample.git) and install them in /usr/local path. It can be changed using the following attributes.

* `node[:dynamo][:source][:repo]` - git repository path where dynamo application files are stored.
* `node[:dynamo][:install_path]` - installation path for dynamo application.
* `node[:dynamo][:service][:name]` - name of dynamo start/stop service.
* `node[:dynamo][:service][:user]` - user for starting dynamo application.
* `node[:dynamo][:service][:port]` - http port name for serving dynamo application.

## Notes
### Starting/Stopping Service
The application is registered to upstart. It can be started/stopped using `start` and `stop` command, followed after the service name`node[:dynamo][:service][:name]`.

```Shell
$ start dynamo_service
dynamo_service start/running

$ stop dynamo_service
dynamo_service stop/waiting
```
