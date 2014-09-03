{%- from 'spark/settings.sls' import version with context %}

include:
  - spark

spark-hdfs:
  cmd.run:
    - name: |
        cp -r /usr/lib/spark /tmp/{{ version }};
        tar -zcvf /tmp/{{ version }}.tgz /tmp/{{ version }} > /dev/null 2>&1;
        hadoop fs -put /tmp/{{ version }}.tgz /tmp;
        # rm -rf /tmp/{{ version }}.tgz /tmp/{{ version }};
    - user: hdfs
    - unless: hadoop fs -test -e /tmp/{{ version }}.tgz
    - require:
      - sls: spark
