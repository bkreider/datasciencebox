include:
  - users
  - conda
  - python.nltk

base:
  pkg.installed:
    - names:
      - build-essential
  conda.managed:
    - name: /home/dsb/envs/base
    - requirements: salt://python/requirements.txt
    - user: dsb
    - require:
      - sls: conda
      - sls: users
