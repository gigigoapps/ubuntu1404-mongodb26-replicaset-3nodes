## Vagrant :: Ubuntu 14.04 64 bits + MongoDB 2.6 with Replica Set of 3 nodes :: Puppet script ##

node /^node\d+$/ {
    group { 'puppet': ensure => present }

    Exec {
        path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/', '/usr/local/bin/' ],
        logoutput => 'on_failure'
    }

    File { owner => 0, group => 0, mode => 0644 }

    class { 'apt': }

    package { [
            'fabric',
        ]:
        ensure  => 'installed'
    }

    # Mongo install
    # This should install mongodb server and client, in the latest mongodb-org version
    class {'::mongodb::globals':
        manage_package_repo => true,
        server_package_name => 'mongodb-org',
        bind_ip             => ['0.0.0.0']
    } ->
    class {'::mongodb::server':
        journal => true,
        replset => 'test'        
    }->
    class {'::mongodb::client': }
}
