base:
  'dsb-base':
    - user.key
    - user.zsh
    # - user.s3cmd
    # - ipnotebook

  'ipengine-*':
    - ipcluster.engine

  'roles:namenode':
    - match: grain
    - cdh5.hadoop.namenode
    - cdh5.hadoop.users
  'roles:datanode':
    - match: grain
    - cdh5.hadoop.datanode

  'roles:mesos-master':
    - match: grain
    - mesos.master
  'roles:mesos-slave':
    - match: grain
    - mesos.slave
