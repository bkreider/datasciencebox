include:
  - python

controller-pkgs:
  conda.installed:
    - name: pyzmq,ipython
    - env: /home/dsb/envs/base
    - user: dsb
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
  file.directory:
    - name: /var/log/ipython
  supervisord.running:
    - restart: False
    - require:
      - file: ipcontroller
      - file: ipcontroller.conf
      - conda: controller-pkgs
      - module: update-supervisor

/srv/salt/ipcluster/files/copied-ipcontroller-engine.json:
  file.copy:
    - source: /home/dsb/.ipython/profile_default/security/ipcontroller-engine.json
    - force: True
    - user: dsb
    - watch:
      - supervisord: ipcontroller
