base:
  'roles:notebook':
    - match: grain
    - users
    - ipython.notebook

  'roles:ipython-engine':
    - match: grain
    - ipython.engine

  'roles:mesos-master':
    - match: grain
    - mesos.master
  'roles:mesos-slave':
    - match: grain
    - mesos.slave

  'roles:namenode':
    - match: grain
    - cdh5.hadoop.namenode
    - cdh5.hadoop.users
  'roles:datanode':
    - match: grain
    - cdh5.hadoop.datanode
