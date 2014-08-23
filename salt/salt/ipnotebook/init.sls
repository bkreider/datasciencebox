include:
  - python

/home/ubuntu/notebooks:
  file.directory:
    - user: ubuntu
    - makedirs: True

ipython-notebook:
  conda.installed:
    - env: /home/ubuntu/envs/base
    - user: ubuntu
    - require:
      - sls: python

ipnotebook.conf:
  pkg.installed:
    - name: supervisor
  file.managed:
    - name: /etc/supervisor/conf.d/ipnotebook.conf
    - source: salt://ipnotebook/files/supervisord.conf
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
  supervisord.running:
    - restart: False
    - require:
      - file: ipnotebook.conf
      - module: update-supervisor
