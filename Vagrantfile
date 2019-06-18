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
  config.vm.define 'pgdb01', primary: true do |pgdb01|
    pgdb01.vm.box = 'cmc/cis-centos76'
    pgdb01.vm.hostname = 'pgdb01.mdt-cmc.local'
    pgdb01.vm.network 'private_network', bridge: 'vboxnet5', ip: '10.10.10.208'

    pgdb01.vm.provider 'virtualbox' do |vb|
      vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
      vb.memory = 2048
      vb.customize ['modifyvm', :id, '--vram', '20']
      file_to_disk = './tmp/pgdb01.vdi'
      unless File.exist?(file_to_disk)
        vb.customize ['createhd', '--filename', file_to_disk, '--size', (32 * 1024)]
      end
      vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
      vb.gui = true
      vb.name = 'pgdb01'
    end
    #run provisioning
    pgdb01.vm.synced_folder 'puppet/hieradata', '/etc/puppetlabs/code/environments/production/hieradata/'
    pgdb01.vm.synced_folder 'puppet/manifests', '/etc/puppetlabs/code/environments/production/manifests/'
    pgdb01.vm.synced_folder 'puppet/modules', '/etc/puppetlabs/code/environments/production/modules/'
    pgdb01.vm.provision :shell,
      path: 'bootstrap.sh',
      upload_path: '/home/vagrant/bootstrap.sh'
  end
  config.vm.define 'pgdb02', autostart: true do |pgdb02|
    pgdb02.vm.box = 'cmc/cis-centos76'
    pgdb02.vm.hostname = 'pgdb02.mdt-cmc.local'
    pgdb02.vm.network 'private_network', bridge: 'vboxnet5', ip: '10.10.10.209'

    pgdb02.vm.provider 'virtualbox' do |vb|
      vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
      vb.memory = 2048
      vb.customize ['modifyvm', :id, '--vram', '20']
      file_to_disk = './tmp/pgdb02.vdi'
      unless File.exist?(file_to_disk)
        vb.customize ['createhd', '--filename', file_to_disk, '--size', (32 * 1024)]
      end
      vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
      vb.gui = true
      vb.name = 'pgdb02'
    end
    #run provisioning
    pgdb02.vm.synced_folder 'puppet/hieradata', '/etc/puppetlabs/code/environments/production/hieradata/'
    pgdb02.vm.synced_folder 'puppet/manifests', '/etc/puppetlabs/code/environments/production/manifests/'
    pgdb02.vm.synced_folder 'puppet/modules', '/etc/puppetlabs/code/environments/production/modules/'
    pgdb02.vm.provision :shell,
      path: 'bootstrap.sh',
      upload_path: '/home/vagrant/bootstrap.sh'
  end
end
