include:
  - python

engine-pkgs:
  conda.installed:
    - name: pyzmq,ipython
    - env: /home/ubuntu/envs/base
    - user: ubuntu
    - require:
      - sls: python

ipcontroller-engine.json:
  file.managed:
    - name: /home/ubuntu/.ipython/profile_default/security/ipcontroller-engine.json
    - source: salt://ipcluster/files/copied-ipcontroller-engine.json
    - makedirs: True
    - user: ubuntu

ipengine.conf:
  pkg.installed:
    - name: supervisor
  file.managed:
    - name: /etc/supervisor/conf.d/ipengine.conf
    - source: salt://ipcluster/files/ipengine.conf
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
  supervisord.running:
    - name: {{ 'ipengine:ipengine_%02d' % pnumber }}
    - restart: False
    - user: ubuntu
    - require:
      - conda: engine-pkgs
      - file: ipengine.conf
      - file: ipcontroller-engine.json
{% endfor %}
