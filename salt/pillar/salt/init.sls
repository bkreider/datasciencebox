salt:
  minion:
    id: dsb-master
    master: localhost

    mine_functions:
      network.get_hostname: '[]'
      network.interfaces: '[]'
      network.ip_addrs:
        - eth1
    mine_interval: 2

  master:
    auto_accept: True

  cloud:
    providers:
      {% macro providers() %}{% include 'salt/providers.sls' ignore missing %}{% endmacro %}
      {{ providers() | indent(width=6) }}

    certs:
      {% macro certs() %}{% include 'salt/certs.sls' ignore missing %}{% endmacro %}
      {{ certs() | indent(width=6) }}

    profiles:
      {% macro profiles() %}{% include 'salt/profiles.sls' ignore missing %}{% endmacro %}
      {{ profiles() | indent(width=6) }}
