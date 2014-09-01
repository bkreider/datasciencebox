{%- set force_mine_update = salt['mine.send']('network.get_hostname') %}

{%- set masters = salt['mine.get']('roles:mesos-master', 'network.get_hostname', 'grain') %}
{%- set master_fqdn = masters.values()[0] %}
