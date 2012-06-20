# Class: nginx::service
#
# This module manages NGINX service management and vhost rebuild
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class nginx::service {
  exec { 'rebuild-nginx-vhosts':
    command     => "for vhost in `ls -1 ${nginx::params::nx_temp_dir}/nginx.d/ | sed 's/\(.*\)-\([0-9][0-9][0-9]\).*/\1/' | uniq`; do /bin/cat ${nginx::params::nx_temp_dir}/nginx.d/\$vhost* > ${nginx::params::nx_conf_dir}/sites-available/\$vhost; done",
#    refreshonly => true,
    provider => shell,
    subscribe   => File["${nginx::params::nx_temp_dir}/nginx.d"],
  }
  service { "nginx":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => Exec['rebuild-nginx-vhosts'],
  }
}
