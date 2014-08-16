{% from "salt/package-map.jinja" import pkgs with context %}
{% set cloud = pillar.get('salt-cloud', {}) -%}

python-pip:
  pkg.installed

pycrypto:
  pip.installed:
    - require:
      - pkg: python-pip

crypto:
  pip.installed:
    - require:
      - pkg: python-pip

apache-libcloud:
  pip.installed:
    - require:
      - pkg: python-pip

salt-cloud:
  pkg.installed:
    - name: {{ pkgs['salt-cloud'] }}
    - require:
      - pip: apache-libcloud
      - pip: pycrypto
      - pip: crypto

{% for cert in cloud['certs'] %}
{% for type in ['pem'] %}
cloud-cert-{{ cert }}-pem:
  file.managed:
    - name: /etc/salt/cloud.providers.d/key/{{ cert }}.pem
    - source: salt://salt/files/key
    - template: jinja
    - makedirs: True
    - user: root
    - group: root
    - mode: 600
    - defaults:
      key: {{ cert }}
      type: {{ type }}
{% endfor %}
{% endfor %}

{% for provider in cloud['providers'] %}
salt-cloud-provider-{{ provider }}:
  file.managed:
    - name: /etc/salt/cloud.providers.d/{{ provider }}.conf
    - template: jinja
    - source: salt://salt/files/cloud.providers.d.conf
    - makedirs: True
    - context:
      id: {{ provider }}
      values: {{ cloud['providers'][provider] }}
{% endfor %}

{% for profile in cloud['profiles'] %}
salt-cloud-profile-{{ profile }}:
  file.managed:
    - name: /etc/salt/cloud.profiles.d/{{ profile }}.conf
    - template: jinja
    - source: salt://salt/files/cloud.profiles.d.conf
    - makedirs: True
    - context:
      id: {{ profile }}
      values: {{ cloud['profiles'][profile] }}
{% endfor %}
