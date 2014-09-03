salt:
  minion:
    id: dsb-base
    master: localhost

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
