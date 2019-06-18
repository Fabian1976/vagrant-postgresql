# Class to load modules needed to install a PostgreSQL server
#
# @example
#  class { '::profile::postgresql::server':
#    instancename => 'postgres'
#  }
#
# @param instancename Name if the instance to create
# @param dbversion Version of PostgreSQL release
# @param config_entries Config entries to modify in pgdata/postgresql.conf
# @param pg_hba_rules HBA-rules to create in pgdata/pg_hba.conf
# @param manage_repo Should the module manage it's own repo? (or is there a Satellite)
# @param datadir Base dir of where to create the database
# @param use_seperate_partition Create a seperate partition or not (additional disk as a partition)
# @param partition_fs_type Partition type of the seperate partition
# @param db_disk List of disks to assign to the seperate partition with LVM. Is only used when use_seperate_partition = true
# @param vgname Name of the volume group LVM will create
# @param db_partition_size Size of the partition (example: 64G). When set to undef, the maximum size of the disks is used
# @param postgres_password Password of the default postgres user
#
class profile::postgresql::server (
  String[1]        $instancename,
  String[1]        $dbversion = '9.4',
  Optional[Hash]   $config_entries = undef,
  Optional[Hash]   $pg_hba_rules = undef,
  Boolean          $manage_repo = false,
  String[1]        $datadir = '/database',
  Boolean          $use_seperate_partition = false,
  String[1]        $partition_fs_type = 'xfs',
  Array[String]    $db_disk = [ '/dev/sdb' ],
  String[1]        $vgname = 'vg_database',
  Optional[String] $db_partition_size = undef,
  String[1]        $postgres_password = 'postgres',
){
  file { $datadir:
    ensure  => directory,
    mode    => '0755',
    seltype => 'postgresql_db_t',
  }
  file { "${datadir}/${instancename}":
    ensure  => directory,
    mode    => '0755',
    seltype => 'postgresql_db_t',
  }
  if $use_seperate_partition {
    class { '::lvm':
      volume_groups => {
        $vgname => {
          physical_volumes => $db_disk,
          logical_volumes  => {
            'database' => {
              'size'              => $db_partition_size,
              'mountpath'         => $datadir,
              'mountpath_require' => true,
              'fs_type'           => $partition_fs_type,
            },
          },
        },
      },
      require       => File[$datadir],
      before        => File["${datadir}/${instancename}"],
    }
  }
  class { '::postgresql::globals':
    manage_package_repo => $manage_repo,
    version             => $dbversion,
    datadir             => "${datadir}/${instancename}/pgdata",
  }
  ->class { '::postgresql::server':
    require           => File["${datadir}/${instancename}"],
    postgres_password => $postgres_password,
    listen_addresses  => '*',
  }
  if $config_entries {
    create_resources('postgresql::server::config_entry', $config_entries)
  }
  if $pg_hba_rules {
    create_resources('postgresql::server::pg_hba_rule', $pg_hba_rules)
  }
}
