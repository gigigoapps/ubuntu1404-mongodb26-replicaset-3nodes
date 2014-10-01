# Vagrant :: Ubuntu 14.04 64 bits + MongoDB 2.6 with Replica Set of 3 nodes #

This project uses Vagrant to mount and deploy a test environment with 3 virtual machines having Ubuntu 14.04 and MongoDB 2.6, mounting a Replica Set of 3 nodes

## Requisites

### You will need:

  * Git 1.7+
  * Vagrant v1.6.5 + (http://vagrantup.com)
  * Virtualbox v4.3.16 + (https://www.virtualbox.org/)

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

---

## Known issues

---

## ToDo
