maintainer       "Pedro Axelrud"
maintainer_email "pedroaxl@gmail.com"
license          "MIT"
description      "Installs sqlite dev libs"
long_description "Please refer to README.md"
version          "0.0.1"

recipe "sqlite-dev", "Installs sqlite development packages"

%w[ubuntu debian centos redhat suse fedora].each do |os|
  supports os
end
