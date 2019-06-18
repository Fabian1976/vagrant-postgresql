# == Class: role::postgresql::server
#
# Install PostgreSQL server
#
# === Authors
#
# Fabian van der Hoeven <fabian.vanderhoeven@vermont24-7.com>
#
class role::postgresql::server {
  include profile::postgresql::server
}
