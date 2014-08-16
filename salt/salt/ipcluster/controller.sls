include:
  - python
  - supervisor

controller-pkgs:
  conda.installed:
    - name: pyzmq,ipython
    - env: /home/ubuntu/envs/base
    - user: ubuntu
    - require:
      - sls: python

ipcontroller:
  supervisord.running:
    - conf_file: /home/ubuntu/supervisor/supervisord.conf
    - restart: False
    - update: False
    - user: ubuntu
    - require:
      - sls: supervisor
      - conda: controller-pkgs

/srv/salt/ipcluster/files/copied-ipcontroller-engine.json:
  file.copy:
    - source: /home/ubuntu/.ipython/profile_default/security/ipcontroller-engine.json
    - force: True
    - user: ubuntu
    - watch:
      - supervisord: ipcontroller
