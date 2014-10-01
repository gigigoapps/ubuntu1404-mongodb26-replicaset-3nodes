# -*- coding: utf-8 -*-

from fabric.api import *
from fabric.contrib.console import confirm

env.user = "root"
env.parallel=False
env.timeout=1
env.warn_only=True

# Mount replica set
def mountreplicaset():
    local("echo 'rs.initiate()' | mongo")
    local("sleep 60")
    local("echo \"rs.add( { '_id': 1, 'host': 'node2:27017', 'priority': 0.5 } )\" | mongo")
    local("echo \"rs.add( { '_id': 2, 'host': 'node3:27017', 'priority': 0.5 } )\" | mongo")
