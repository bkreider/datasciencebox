include:
  - python

/home/dsb/notebooks:
  file.directory:
    - user: dsb
    - makedirs: true

ipython-notebook:
  conda.installed:
    - env: /home/dsb/envs/base
    - user: dsb
    - require:
      - sls: python

notebook.conf:
  pkg.installed:
    - name: supervisor
  file.managed:
    - name: /etc/supervisor/conf.d/notebook.conf
    - source: salt://ipython/files/notebook.conf
    - template: jinja
    - makedirs: true
    - require:
      - pkg: notebook.conf

notebook-update-supervisor:
  module.run:
    - name: supervisord.update
    - watch:
      - file: notebook.conf

notebook-service:
  file.directory:
    - name: /var/log/ipython
  supervisord.running:
    - name: notebook
    - restart: true
    - require:
      - conda: ipython-notebook
      - module: notebook-update-supervisor
      - file: notebook.conf
      - file: notebook-service
