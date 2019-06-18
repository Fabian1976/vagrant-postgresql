# == Class: profile::postgresql::server
#
# Install PostgreSQL server with specified config entries and HBA entries
#
# === Parameters
#
# $version:
#   This parameter allows you to set a specifiec version. Defaults to 2.4.5
#
# === Variables
#
# === Authors
#
# Fabian van der Hoeven <fabian.vanderhoeven@vermont24-7.com>
#
class profile::postgresql::server (
  String $dbversion = '9.4',
  $config_entries = undef,
  $pg_hba_rules = undef,
  Boolean $manage_db_repo = false,
  String $datadir = '/database',
  String $instancename = undef,
  Boolean $use_seperate_partition = false,
  String $partition_fs_type = 'xfs',
  Array $db_disk = [ '/dev/sdb' ],
  $db_partition_size = undef,
  String $postgres_password = 'postgres',
){
  assert_type(Array, $db_disk) | $expected, $actual | {
    fail "Parameter ${title}::db_disk should be '${expected}', not '${actual}'."
  }
  assert_type(String, $instancename) | $expected, $actual | {
    fail "Parameter ${title}::instancename should be '${expected}', not '${actual}'."
  }

  file { $datadir:
    ensure  => directory,
    mode    => '0755',
  }
  file { "${datadir}/${instancename}":
    ensure  => directory,
    mode    => '0775',
  }
  if $use_seperate_partition {
    class {'lvm':
      volume_groups => {
        'vg_database' => {
          physical_volumes => $db_disk,
          logical_volumes  => {
            'database' => {
              'size'              => $db_partition_size,
              'mountpath'         => $datadir,
              'mountpath_require' => true,
              'fs_type'           => $partition_fs_type
            },
          },
        },
      },
      require       => File[$datadir],
      before        => File["${datadir}/${instancename}"]
    }
  }
  class { 'postgresql::globals':
    manage_package_repo => $manage_db_repo,
    version             => $dbversion,
    datadir             => "${datadir}/${instancename}/pgdata",
  }
  ->class { 'postgresql::server':
    require           => File["${datadir}/${instancename}"],
    postgres_password => $postgres_password,
    listen_addresses  => '*'
  }
  if $config_entries != undef {
    assert_type(Hash, $config_entries) | $expected, $actual | { fail "Parameter ${title}::config_entries should be '${expected}', not '${actual}'." }
    create_resources('postgresql::server::config_entry', $config_entries)
  }
  if $pg_hba_rules != undef {
    assert_type(Hash, $pg_hba_rules) | $expected, $actual | { fail "Parameter ${title}::pg_hba_rules should be '${expected}', not '${actual}'." }
    create_resources('postgresql::server::pg_hba_rule', $pg_hba_rules)
  }


}
