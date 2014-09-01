include:
  - mesos.repo
  - mesos.conf
  - cdh5.zookeeper

mesos-master-pkg:
  pkg.installed:
    - name: mesos
    - require:
      - sls: mesos.repo

mesos-master:
  service.running:
    - name: mesos-master
    - enable: True
    - require:
      - sls: mesos.conf
      - sls: cdh5.zookeeper
      - pkg: mesos-master-pkg

mesos-slave-dead:
  service.dead:
    - name: mesos-slave
    - require:
      - pkg: mesos-master-pkg
  cmd.run:
    - name: echo manual > /etc/init/mesos-slave.override
    - require:
      - pkg: mesos-master-pkg
