{%- from 'mesos/settings.sls' import master_fqdn with context %}

include:
  - hostsfile

/etc/mesos/zk:
  file.managed:
    - source: salt://mesos/etc/mesos/zk
    - template: jinja
    - user: root
    - group: root
    - makedirs: true
    - file_mode: 644
    - context:
      master_host: {{ master_fqdn }}
    - require:
      - sls: hostsfile
