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
    [...]

### Access to the VM's

You can go to any of the deployed VM "inside" with shell prompt in console mode, and then access to the "mongo" server

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
    >

With "vagrant ssh [VM]" you are logged into the desired VM with "vagrant" user. 
But you can enter `sudo -i` command to became "root" user
Or you can also exec `sudo [command]` commands.

---

## Notes

---

## Known issues

---

## ToDo
