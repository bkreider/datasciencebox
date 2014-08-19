#!py
import os
import fnmatch

def run():
  '''
  Add all `*.sls` files to base
  '''
  pillar_path = '/srv/pillar'
  matches = []
  for root, dirnames, filenames in os.walk(pillar_path):
    for filename in fnmatch.filter(filenames, '*.sls'):
      if root == pillar_path:
        matches.append(filename[:-4])
      else:
        root = root.replace('/','.')
        matches.append("{0}.{1}".format(root[len(pillar_path) + 1:], filename[:-4]))

  return {'base': {'*': matches}}
