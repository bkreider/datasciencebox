include:
  - python
  - supervisor

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

{% for pnumber in range(pillar['ipcluster']['nprocesses']) %}
ipengine-{{ pnumber }}:
  supervisord.running:
    - name: {{ 'ipengine:ipengine_%02d' % pnumber }}
    - conf_file: /home/ubuntu/supervisor/supervisord.conf
    - restart: False
    - update: False
    - user: ubuntu
    - require:
      - sls: supervisor
      - conda: engine-pkgs
      - file: ipcontroller-engine.json
{% endfor %}
