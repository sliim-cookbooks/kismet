#
# Cookbook Name:: kismet
# Recipe:: default
#
# Copyright 2013-2016, Tim Smith - tsmith84@gmail.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# install gpsd and enable the service
if node['kismet']['enable_gpsd']
  package 'gpsd'

  template '/etc/default/gpsd' do
    source 'gpsd.erb'
    owner 'root'
    group 'root'
    mode '0644'
  end

  service 'gpsd' do
    supports status: true, restart: true
    action [:enable, :start]
  end
end

# add the apt repository for kismet
apt_repository 'kismet_wireless' do
  uri 'https://www.kismetwireless.net/code/'
  components ['kismet']
  key 'https://www.kismetwireless.net/code/dists/kismet-release.gpg'
  distribution 'precise' # the last distro in their repo
end

# install kismet
package 'kismet' do
  action :install
end

directory node['kismet']['config']['logprefix'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

template '/etc/kismet/kismet.conf' do
  source 'kismet.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(config_opts: node['kismet']['config'])
end
