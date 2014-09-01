include:
  - mesos.repo
  - mesos.conf

mesos-slave-pkg:
  pkg.installed:
    - name: mesos
    - require:
      - sls: mesos.repo

mesos-slave:
  service.running:
    - name: mesos-slave
    - enable: True
    - require:
      - sls: mesos.conf
      - pkg: mesos-slave-pkg

mesos-master-dead:
  service.dead:
    - name: mesos-master
    - require:
      - pkg: mesos-slave-pkg
  cmd.run:
    - name: echo manual > /etc/init/mesos-slave.override
    - require:
      - pkg: mesos-slave-pkg

zookeeper-dead:
  service.dead:
    - name: zookeeper
    - require:
      - pkg: mesos-slave-pkg
  cmd.run:
    - name: echo manual > /etc/init/zookeeper.override
    - require:
      - pkg: mesos-slave-pkg
