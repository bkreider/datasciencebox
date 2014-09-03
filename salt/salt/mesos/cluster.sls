include:
  - salt.master
  - salt.cloud

{% set masters = pillar['mesos']['cluster']['masters'] %}
{% set slaves = pillar['mesos']['cluster']['slaves'] %}
/etc/salt/cloud.maps.d/mesos-cluster.map:
  file.managed:
    - contents: |
        mesos-master:
          {% for instance in range(masters) %}
          - mesos-master-{{ instance + 1 }}
          {% endfor %}
        mesos-slave:
          {% for instance in range(slaves) %}
          - mesos-slave-{{ instance + 1 }}
          {% endfor %}
    - require:
      - sls: salt.master
      - sls: salt.cloud

create-mesos-cluster:
  cmd.run:
    - name: salt-cloud -m /etc/salt/cloud.maps.d/mesos-cluster.map -P -y
    - require:
      - file: /etc/salt/cloud.maps.d/mesos-cluster.map
