include:
  - python

ipengine-pkgs:
  conda.installed:
    - name: pyzmq,ipython
    - env: /home/dsb/envs/base
    - user: dsb
    - require:
      - sls: python

ipcontroller-engine.json:
  file.managed:
    - name: /home/dsb/.ipython/profile_default/security/ipcontroller-engine.json
    - source: salt://ipython/files/copied-ipcontroller-engine.json
    - makedirs: true
    - user: dsb

ipengine.conf:
  pkg.installed:
    - name: supervisor
  file.managed:
    - name: /etc/supervisor/conf.d/ipengine.conf
    - source: salt://ipython/files/engine.conf
    - template: jinja
    - makedirs: true
    - context:
      processes: {{ pillar['ipython']['cluster']['processes'] }}
    - require:
      - pkg: ipengine.conf

ipengine-update-supervisor:
  module.run:
    - name: supervisord.update
    - watch:
      - file: ipengine.conf

{% for pnumber in range(pillar['ipython']['cluster']['processes']) %}
ipengine-{{ pnumber }}-service:
  file.directory:
    - name: /var/log/ipython
  supervisord.running:
    - name: {{ 'ipengine:ipengine_%02d' % pnumber }}
    - restart: true
    - user: dsb
    - require:
      - conda: ipengine-pkgs
      - file: ipengine.conf
      - module: ipengine-update-supervisor
      - file: ipcontroller-engine.json
      - file: ipengine-{{ pnumber }}-service
{% endfor %}
