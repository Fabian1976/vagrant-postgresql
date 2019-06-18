# vagrant-postgresql
Vagrant box to test my PostgreSQL puppet code

I use it on a Mac book

## Installation
Make sure Vagrant is installed (duh) with the hostmanager plugin (`vagrant plugin install vagrant-hostmanager`).

Make sure these packages are installed:
```
rubygem-bundler
git
```

Clone this repo:
```
git clone https://github.com/Fabian1976/vagrant-postgresql.git
```

Execute these steps:
```
$ cd vagrant-postgresql
$ bundle install
$ cd puppet
$ librarian-puppet install
$ cd ..
$ vagrant up pgdb01
```

When it is finished, PostgreSQL should be accessible via port 5432

In the Vagrantfile there is also a placeholder for a second server (pgdb02) which doesn't do anything yet. It is in preparation for streaming replication.
