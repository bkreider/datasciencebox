include:
  - python
  - supervisor

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

ipnotebook:
  supervisord.running:
    - conf_file: /home/ubuntu/supervisor/supervisord.conf
    - restart: False
    - user: ubuntu
    - require:
      - sls: supervisor
      - conda: ipython-notebook
      - file: /home/ubuntu/notebooks
