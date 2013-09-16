#
# Cookbook Name:: sqlite-dev
# Recipe:: default
#
# Copyright 2012, Pedro Axelrud
#

package "sqlite-dev" do
  package_name value_for_platform(
    %w[centos redhat suse fedora] => { "default" => "sqlite-devel" },
    "default" => "libsqlite3-dev"
  )
end
