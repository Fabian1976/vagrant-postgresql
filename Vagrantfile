# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.vm.provision :hostmanager
#  config.vm.box = "bento/centos-7.4"
  config.vm.box = 'cmc/cis-centos76'
  config.vm.synced_folder 'puppet/hieradata', '/etc/puppetlabs/code/environments/production/hieradata/'
  config.vm.synced_folder 'puppet/manifests', '/etc/puppetlabs/code/environments/production/manifests/'
  config.vm.synced_folder 'puppet/modules', '/etc/puppetlabs/code/environments/production/modules/'
  config.vm.provision :shell,
    path: 'bootstrap.sh',
    upload_path: '/home/vagrant/bootstrap.sh'
  config.vm.hostname = 'pgdb01.mdt-cmc.local'
  config.vm.network 'private_network', bridge: 'vboxnet5', ip: '10.10.10.208'
  config.vm.provider 'virtualbox' do |vb|
    vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
    vb.memory = 2048
    vb.customize ['modifyvm', :id, '--vram', '20']
    file_to_disk = './tmp/large_disk.vdi'
    unless File.exist?(file_to_disk)
      vb.customize ['createhd', '--filename', file_to_disk, '--size', (32 * 1024)]
    end
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
    vb.gui = true
    vb.name = 'pgdb001'
  end
end
