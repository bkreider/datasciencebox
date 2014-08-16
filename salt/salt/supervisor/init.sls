include:
  - user.ubuntu

/home/ubuntu/log:
  file.directory:
    - makedirs: True
    - user: ubuntu

/home/ubuntu/supervisor:
  file.directory:
    - makedirs: True
    - user: ubuntu

supervisord-conf:
  file.managed:
    - name: /home/ubuntu/supervisor/supervisord.conf
    - source: salt://supervisor/supervisord.conf
    - template: jinja
    - makedirs: True
    - user: ubuntu
    - require:
      - file: /home/ubuntu/supervisor

supervisor:
  pkg.installed:
    - name: supervisor
  cmd.run:
    - name: supervisord -c /home/ubuntu/supervisor/supervisord.conf
    - unless: test -e /home/ubuntu/supervisor/supervisord.pid
    - user: ubuntu
    - require:
      - pkg: supervisor
      - file: supervisord-conf
      - file: /home/ubuntu/log
