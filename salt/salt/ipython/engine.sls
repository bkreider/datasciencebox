include:
  - python

engine-pkgs:
  conda.installed:
    - name: pyzmq,ipython
    - env: /home/dsb/envs/base
    - user: dsb
    - require:
      - sls: python

ipcontroller-engine.json:
  file.managed:
    - name: /home/dsb/.ipython/profile_default/security/ipcontroller-engine.json
    - source: salt://ipython/files/copied-ipcontroller-engine.json
    - makedirs: True
    - user: dsb

ipengine.conf:
  pkg.installed:
    - name: supervisor
  file.managed:
    - name: /etc/supervisor/conf.d/ipengine.conf
    - source: salt://ipython/files/ipengine.conf
    - template: jinja
    - makedirs: True
    - require:
      - pkg: ipengine.conf

update-supervisor:
  module.run:
    - name: supervisord.update
    - watch:
      - file: ipengine.conf

{% for pnumber in range(pillar['ipcluster']['nprocesses']) %}
ipengine-{{ pnumber }}:
  file.directory:
    - name: /var/log/ipython
  supervisord.running:
    - name: {{ 'ipengine:ipengine_%02d' % pnumber }}
    - restart: False
    - user: dsb
    - require:
      - file: ipengine-{{ pnumber }}
      - file: ipengine.conf
      - conda: engine-pkgs
      - module: update-supervisor
      - file: ipcontroller-engine.json
{% endfor %}
