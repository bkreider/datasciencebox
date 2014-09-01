{%- from 'cdh5/settings.sls' import datanode_dirs with context %}

include:
  - java
  - cdh5.repo
  - cdh5.hadoop.conf

hadoop-hdfs-datanode:
  pkg.installed:
    - require:
      - sls: cdh5.repo

{% for dir in datanode_dirs %}
{{ dir }}:
  file.directory:
    - makedirs: true
    - user: hdfs
    - mode: 700
{% endfor %}

start-hadoop-hdfs-datanode:
  service.running:
    - name: hadoop-hdfs-datanode
    - enable: True
    - require:
      {% for dir in datanode_dirs %}
      - file: {{ dir }}
      {% endfor %}
