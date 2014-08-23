{% from "salt/package-map.jinja" import pkgs with context %}
{% set salt = pillar.get('salt', {}) -%}
{% set cloud = salt.get('cloud', {}) -%}

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

{% for provider in cloud['providers'] %}
salt-cloud-provider-{{ provider }}:
  file.managed:
    - name: /etc/salt/cloud.providers.d/{{ provider }}.conf
    - template: jinja
    - source: salt://salt/files/ec2.provider.conf
    - makedirs: True
    - context:
      id: {{ provider }}
      values: {{ cloud['providers'][provider] }}
{% endfor %}

{% for cert in cloud['certs'] %}
cloud-cert-{{ cert }}-pem:
  file.managed:
    - name: /etc/salt/cloud.providers.d/key/{{ cert }}.pem
    - source: salt://salt/files/key
    - template: jinja
    - makedirs: True
    - user: root
    - group: root
    - mode: 600
    - context:
      value: cloud['certs'][certs]
{% endfor %}

{% for profile in cloud['profiles'] %}
salt-cloud-profile-{{ profile }}:
  file.managed:
    - name: /etc/salt/cloud.profiles.d/{{ profile }}.conf
    - template: jinja
    - source: salt://salt/files/ec2.profile.conf
    - makedirs: True
    - context:
      id: {{ profile }}
      values: {{ cloud['profiles'][profile] }}
{% endfor %}
