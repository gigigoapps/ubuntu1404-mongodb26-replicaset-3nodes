# Vagrant :: Ubuntu 14.04 64 bits + MongoDB 2.6 with Replica Set of 3 nodes #

This project uses Vagrant to mount and deploy a test environment with 3 virtual machines having Ubuntu 14.04 and MongoDB 2.6, mounting a Replica Set of 3 nodes

## Requisites

### You will need:

  * Git 1.7+
  * Vagrant v1.6.5 + (http://vagrantup.com)
  * Virtualbox v4.3.16 + (https://www.virtualbox.org/)
  * 1.5 GB of free RAM

## Do the work

### Clone this repositoriy with submodules (they are puppet submodules)

    $ git clone --recursive https://github.com/pedroamador/ubuntu1404-mongodb26-replicaset-3nodes
    [...]
    $ cd ubuntu1404-mongodb26-replicaset-3nodes
    [...]

### Start the VM

    ubuntu1404-mongodb26-replicaset-3nodes$ vagrant up
    Bringing machine 'node1' up with 'virtualbox' provider...
    Bringing machine 'node2' up with 'virtualbox' provider...
    Bringing machine 'node3' up with 'virtualbox' provider...
    ==> node1: Importing base box 'puppetlabs/ubuntu-14.04-64-puppet'...
    ==> node1: Matching MAC address for NAT networking...
    ==> node1: Checking if box 'puppetlabs/ubuntu-14.04-64-puppet' is up to date...
    [...]

### Mount the replica set

This process takes about 60 seconds to complete.

        
    ubuntu1404-mongodb26-replicaset-3nodes$ vagrant ssh node1 -c "sudo fab -f /opt/fabric/fabfile.py mountreplicaset"
    [localhost] local: echo 'rs.initiate()' | mongo
    MongoDB shell version: 2.6.4
    connecting to: test
    {
        "info2" : "no configuration explicitly specified -- making one",
        "me" : "node1:27017",
        "info" : "Config now saved locally.  Should come online in about a minute.",
        "ok" : 1
    }
    bye
    [localhost] local: sleep 60
    [localhost] local: echo "rs.add( { '_id': 1, 'host': 'node2:27017', 'priority': 0.5 } )" | mongo
    MongoDB shell version: 2.6.4
    connecting to: test
    { "ok" : 1 }
    bye
    [localhost] local: echo "rs.add( { '_id': 2, 'host': 'node3:27017', 'priority': 0.5 } )" | mongo
    MongoDB shell version: 2.6.4
    connecting to: test
    { "ok" : 1 }
    bye

    Done.
    Connection to 127.0.0.1 closed.

### Access to the VM's

You can go to any of the deployed VM "inside" with shell prompt in console mode, and then access to the "mongo" server, ie check replica set status on node1

        
    ubuntu1404-mongodb26-replicaset-3nodes$ vagrant ssh node1
    Welcome to Ubuntu 14.04 LTS (GNU/Linux 3.13.0-24-generic x86_64)

     * Documentation:  https://help.ubuntu.com/
    vagrant@node1:~$ mongo
    MongoDB shell version: 2.6.4
    connecting to: test
    Welcome to the MongoDB shell.
    For interactive help, type "help".
    For more comprehensive documentation, see
        http://docs.mongodb.org/
    Questions? Try the support group
        http://groups.google.com/group/mongodb-user
    test:PRIMARY> rs.status
    function () { return db._adminCommand("replSetGetStatus"); }
    test:PRIMARY> rs.status()
    {
        "set" : "test",
        "date" : ISODate("2014-10-01T07:22:44Z"),
        "myState" : 1,
        "members" : [
            {
                "_id" : 0,
                "name" : "node1:27017",
                "health" : 1,
                "state" : 1,
                "stateStr" : "PRIMARY",
                "uptime" : 554,
                "optime" : Timestamp(1412148080, 2),
                "optimeDate" : ISODate("2014-10-01T07:21:20Z"),
                "electionTime" : Timestamp(1412148020, 2),
                "electionDate" : ISODate("2014-10-01T07:20:20Z"),
                "self" : true
            },
            {
                "_id" : 1,
                "name" : "node2:27017",
                "health" : 1,
                "state" : 2,
                "stateStr" : "SECONDARY",
                "uptime" : 84,
                "optime" : Timestamp(1412148080, 2),
                "optimeDate" : ISODate("2014-10-01T07:21:20Z"),
                "lastHeartbeat" : ISODate("2014-10-01T07:22:42Z"),
                "lastHeartbeatRecv" : ISODate("2014-10-01T07:22:42Z"),
                "pingMs" : 1,
                "syncingTo" : "node1:27017"
            },
            {
                "_id" : 2,
                "name" : "node3:27017",
                "health" : 1,
                "state" : 2,
                "stateStr" : "SECONDARY",
                "uptime" : 84,
                "optime" : Timestamp(1412148080, 2),
                "optimeDate" : ISODate("2014-10-01T07:21:20Z"),
                "lastHeartbeat" : ISODate("2014-10-01T07:22:42Z"),
                "lastHeartbeatRecv" : ISODate("2014-10-01T07:22:43Z"),
                "pingMs" : 1,
                "syncingTo" : "node1:27017"
            }
        ],
        "ok" : 1
    }

With "vagrant ssh [VM]" you are logged into the desired VM with "vagrant" user. 
But you can enter `sudo -i` command to became "root" user
Or you can also exec `sudo [command]` commands.

---

## Notes

There are some news since our first project in the series https://github.com/pedroamador/ubuntu1404-mongodb26

### More ammount of RAM

You need at least 1.5 GB of free RAM to deploy the three VM's. 

### Multiple nodes

This project uses the Vagrant advantage of creating multiple VM's in with a single "Vagrantfile" deploy file.

Every VM has its own network IP, hostname and forwarded ports. You can connect with a Mongo client to the mongo process of any or the three nodes

* 10.11.12.11:27017 => Access to the mongo process of "node1"
* 10.11.12.12:27017 => Access to the mongo process of "node2"
* 10.11.12.12:27017 => Access to the mongo process of "node2"

Also, there is forwarded ports from your local IP to every node:

* YOUR_LOCAL_IP:27017 => node1:27017
* YOUR_LOCAL_IP:27018 => node2:27017
* YOUR_LOCAL_IP:27019 => node3:27017

This menans that anyone on your local network can connect at the three Mongo process hosted in every "node" VM. Imagine that you have the IP 192.168.1.100, and you have the three nodes created, and the replica set builded. You can access from another PC of your local network (ie called "othercompuer"), 

    
    user@othercomputer:~$ mongo --host 192.168.1.100 --port 27017
    MongoDB shell version: 2.6.4
    connecting to: 192.168.1.100:27017/test
    test:PRIMARY> db.serverStatus()
    {
        "host" : "node1",
        "version" : "2.6.4",
        "process" : "mongod",

        [...]

        },
        "ok" : 1
    }        
    test:PRIMARY> exit
    bye
    user@othercomputer:~$ mongo --host 192.168.1.100 --port 27018
    MongoDB shell version: 2.6.4
    connecting to: 192.168.1.100:27018/test
    test:SECONDARY> db.serverStatus()
    {
        "host" : "node2",
        "version" : "2.6.4",
        "process" : "mongod",

        [...]

        },
        "ok" : 1
    }        
    test:SECONDARY> exit
    bye
    user@othercomputer:~$ mongo --host 192.168.1.100 --port 27019
    MongoDB shell version: 2.6.4
    connecting to: 192.168.1.100:27019/test
    test:SECONDARY> db.serverStatus()
    {
        "host" : "node3",
        "version" : "2.6.4",
        "process" : "mongod",

        [...]

        },
        "ok" : 1
    }        
    test:SECONDARY> exit
    bye 

### Puppet script news

One puppet file, multiple nodes deployed: conditional deploy: the puppet file "manifest/node.pp" is used in the three nodes.

There is a line

    node /^node\d+$/ {

that use a regular expression to match the tree nodes (node1, node2, node3). With one puppet script we can deploy the tree VM's

Also, we make conditional setup, installing "Fabric" only on the first node. This behaviour is located later in the same "manifes/node.pp" file
    
    [...]
    # Only on VM "node1": fabric install
    if ($hostname == 'node1') {
    [...]

The last trick is to place the hostnames "node1", "node2" and "node3" on the /etc/hosts file with the "host" puppet sentence


    # Hostnames
    host { "node1": ip => "10.11.12.11" }
    host { "node2": ip => "10.11.12.12" }
    host { "node3": ip => "10.11.12.13" }


### Use of Fabric

We use "Fabric" to build the replica set. The build process is done in 4 steps within a fabric task. There is a pause of 60 seconds between the first step (initiate replica set) and the second step (add the second replica set member)

In the  next projects we will make more intensive use of Fabric

You can read more about fabric at http://www.fabfile.org/

### Performance

You should think that the VM's run into your PC. Don't expect a great performance.

The environment is good for replica set testing, but not for performance testing.

---

## Known issues

During the "vagrant up" step, you get some "Warnings" about deprecated puppet sentences and hiera file locations. You can simply ignore it.

---

## ToDo
