salt:
  master:
    {% macro master() %}{% include 'salt/master.sls' %}{% endmacro %}
    {{ master() | indent(width=4) }}

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
