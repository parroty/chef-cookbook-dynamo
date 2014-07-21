name             "chef-cookbook-dynamo"
maintainer       "parroty"
maintainer_email "parroty00@gmail.com"
license          "Apache"
description      "Install dynamo"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "0.0.1"

depends "build-essential"
depends "openssl"         # depends on build-essential
depends "postgresql"      # depends on openssl
