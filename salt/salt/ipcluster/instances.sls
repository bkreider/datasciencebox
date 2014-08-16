include:
  - salt.master
  - salt.cloud

{% set ninstances = salt['pillar.get']('ipcluster')['ninstances'] %}
{% for instance in range(ninstances) %}
ipengine-{{ instance + 1 }}:
  cloud.profile:
    - profile: {{ salt['pillar.get']('ipcluster')['cloud-profile'] }}
    - require:
      - sls: salt.master
      - sls: salt.cloud
{% endfor %}
