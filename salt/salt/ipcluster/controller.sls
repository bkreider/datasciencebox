include:
  - python

controller-pkgs:
  conda.installed:
    - name: pyzmq,ipython
    - env: /home/ubuntu/envs/base
    - user: ubuntu
    - require:
      - sls: python

ipcontroller.conf:
  pkg.installed:
    - name: supervisor
  file.managed:
    - name: /etc/supervisor/conf.d/ipcontroller.conf
    - source: salt://ipcluster/files/ipcontroller.conf
    - template: jinja
    - makedirs: True
    - require:
      - pkg: ipcontroller.conf

update-supervisor:
  module.run:
    - name: supervisord.update
    - watch:
      - file: ipcontroller.conf

ipcontroller:
  supervisord.running:
    - conf_file: /etc/supervisor/supervisord.conf
    - restart: False
    - require:
      - file: ipcontroller.conf
      - module: update-supervisor

/srv/salt/ipcluster/files/copied-ipcontroller-engine.json:
  file.copy:
    - source: /home/ubuntu/.ipython/profile_default/security/ipcontroller-engine.json
    - force: True
    - user: ubuntu
    - watch:
      - supervisord: ipcontroller
