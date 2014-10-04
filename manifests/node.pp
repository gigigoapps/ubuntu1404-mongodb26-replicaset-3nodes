## Vagrant :: Ubuntu 14.04 64 bits + MongoDB 2.6 with Replica Set of 3 nodes :: Puppet script ##

node /^node\d+$/ {
    group { 'puppet': ensure => present }

    Exec {
        path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/', '/usr/local/bin/' ],
        logoutput => 'on_failure'
    }

    File { owner => 0, group => 0, mode => 0644 }

    class { 'apt': }

    # Packages
    package { [
            'atop',
            'ccze',
            'htop',
            'iotop',
            'multitail',
            'ntp'
        ]:
        ensure  => 'installed'
    }

    # Hostnames
    host { "node1": ip => "10.11.12.11" }
    host { "node2": ip => "10.11.12.12" }
    host { "node3": ip => "10.11.12.13" }


    # Mongo install
    # This should install mongodb server and client, in the latest mongodb-org version
    class {'::mongodb::globals':
        manage_package_repo => true,
        server_package_name => 'mongodb-org'
    } ->
    class {'::mongodb::server':
        journal => true,
        replset => 'test',
        bind_ip => [ '0.0.0.0' ]
    }->
    class {'::mongodb::client': }

    # Only on VM "node1": fabric install
    if ($hostname == 'node1') {
        package { [
                'fabric'
            ]:
            ensure  => 'installed'
        }

        # Fabric folder
        file { '/opt/fabric':
            ensure  => 'directory',
            owner   => 'root',
            group   => 'root',
            mode    => 755
        } ->
        file { '/opt/fabric/fabfile.py':
            source  => "puppet:///modules/common/fabfile.py",
            owner   => 'root',
            group   => 'root',
            mode    => 644,
            ensure  => 'present'
        }
    }
}
