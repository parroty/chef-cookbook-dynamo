Description
===========

Manages installation of Dynamo via packages or source.
This cookbook performs the following.
- Download dynamo application from git server.
- Registers dynamo application to upstart service for starting/stopping.
- Setup Ecto and PostgreSQL database.

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
By default, it downloads dynamo sample application files (https://github.com/parroty/dynamo_sample.git) and install them in /usr/local path and listens on "http://hostname:4000". It can be changed using the following attributes.

* `node[:dynamo][:source][:repo]` - git repository path where dynamo application files are stored.
* `node[:dynamo][:install_path]` - installation path for dynamo application.
* `node[:dynamo][:service][:name]` - name of dynamo start/stop service.
* `node[:dynamo][:service][:user]` - user for starting dynamo application.
* `node[:dynamo][:service][:port]` - http port name for serving dynamo application.

## Notes
### Starting/Stopping Service
The application is registered to upstart. It can be started/stopped using `start` and `stop` command, followed after the service name`node[:dynamo][:service][:name]`. The default name is 'dynamo'.

```Shell
$ start dynamo
dynamo start/running

$ stop dynamo
dynamo stop/waiting
```

Using Ecto
==========
By configuring attributes, this cookbook can setup Ecto with PostgreSQL database along with dynamo application.

* `node[:dynamo][:flags][:use_ecto]` - true/false flag to setup Ecto and PostgreSQL.
* `node[:dynamo][:flags][:perform_migration]` - true/false flag to perform Ecto migration (mix ecto.migrate)
* `node[:dynamo][:ecto][:repo_name]` - Repo name for Ecto, which will be used for migration. The default is set as `Repo`.
* `node[:dynamo][:ecto][:database_name]` = Database name for Ecto, which will be used for migration. The default is set as `ecto_simple`.
* `node[:dynamo][:ecto][:database_user]` - Database user to setup on PostgreSQL database. The default is `postgres`.
* `node[:dynamo][:ecto][:database_password]` - Database password to setup on PostgreSQL database. The default is `postgres`.


### Example
The following is an example attributes to setup simple Dynamo application with Ecto database (https://github.com/parroty/dynamo_scaffold). It launches the application on "http://hostname:4000" by default.

Example for vagrant configuration (Vagrantfile).

```ruby
config.vm.provision :chef_solo do |chef|
  chef.json = {
    "dynamo" => {
      "flags" => {
        "use_ecto" => true,
        "perform_migration" => true
      },
      "source" => {
        "repo" => "https://github.com/parroty/dynamo_scaffold.git"
      }
    }
  }
end
```
