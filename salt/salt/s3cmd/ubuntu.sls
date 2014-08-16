include:
  - s3cmd
  - user.ubuntu

s3cmd-config:
  file.managed:
    - name: /home/ubuntu/.s3cfg
    - source: salt://s3cmd/files/s3cfg.template
    - template: jinja
    - user: ubuntu
    - mode: 0600
    - require:
      - sls: user.ubuntu
