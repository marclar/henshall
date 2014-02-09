#
# Cookbook Name:: hubot
# Recipe:: default
#

execute "apt-get-update" do
  command "apt-get update"
  only_if do
    !File.exists?('/var/lib/apt/periodic/update-success-stamp') ||
    (File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
     File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400)
  end
end

%w(build-essential git-core redis-server python-software-properties
  software-properties-common).each do |package_name|
  apt_package package_name do
    action :install
  end
end

execute "add node repo" do
  command "add-apt-repository -y ppa:chris-lea/node.js"
  not_if do
    "apt-cache policy | grep chris-lea"
  end
  notifies :run, resources(:execute => "apt-get-update"), :immediately
end

package "update-notifier-common" do
  ignore_failure true
  notifies :run, resources(:execute => "apt-get-update"), :immediately
end

apt_package "nodejs" do
  action :install
end

execute "install coffee script" do
  command "npm install -g coffee-script"
  creates "/usr/bin/coffee"
end

execute "clone hubot repo" do
  command "git clone #{node[:hubot][:repo]} /usr/local/hubot"
  creates "/usr/local/hubot"
end

execute "install hubot dependencies" do
  command "npm install"
  cwd "/usr/local/hubot"
  creates "/usr/local/hubot/node_modules"
end

user "hubot" do
  shell "/bin/false"
end

file "/var/log/hubot.log" do
  owner "hubot"
  group "hubot"
  mode "0644"
  action :create
end

template "/etc/logrotate.d/hubot" do
  source "hubot-logrotate.erb"
  action :create
  mode "0755"
end

template "/etc/init/hubot.conf" do
  source "hubot-upstart.erb"
  action :create
  mode "0755"
  variables :hubot => node[:hubot]
end

service "hubot" do
  action [ :start ]
  provider Chef::Provider::Service::Upstart
end
