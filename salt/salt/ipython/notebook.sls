include:
  - python

/home/dsb/notebooks:
  file.directory:
    - user: dsb
    - makedirs: True

ipython-notebook:
  conda.installed:
    - env: /home/dsb/envs/base
    - user: dsb
    - require:
      - sls: python

ipnotebook.conf:
  pkg.installed:
    - name: supervisor
  file.managed:
    - name: /etc/supervisor/conf.d/ipnotebook.conf
    - source: salt://ipython/files/notebook.conf
    - template: jinja
    - makedirs: True
    - require:
      - pkg: ipnotebook.conf

update-supervisor:
  module.run:
    - name: supervisord.update
    - watch:
      - file: ipnotebook.conf

ipnotebook:
  file.directory:
    - name: /var/log/ipython
  supervisord.running:
    - restart: False
    - require:
      - file: ipnotebook
      - file: ipnotebook.conf
      - conda: ipython-notebook
      - module: update-supervisor
