include:
  - salt.master
  - salt.cloud

{% set instances = pillar['ipython']['cluster']['instances'] %}
{% for instance in range(instances) %}
ipengine-{{ instance + 1 }}:
  cloud.profile:
    - profile: ipython-engine
    - require:
      - sls: salt.master
      - sls: salt.cloud
{% endfor %}
