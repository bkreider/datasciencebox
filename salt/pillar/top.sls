#!py
import os
import fnmatch

def run():
  '''
  Add all `*.sls` files to base
  '''
  matches = []
  for root, dirnames, filenames in os.walk('.'):
    for filename in fnmatch.filter(filenames, '*.sls'):
      if root == '.':
        matches.append(filename[:-4])
      else:
        root = root.replace('/','.')
        matches.append("{0}.{1}".format(root[2:], filename[:-4]))

  return {'base': {'*': matches}}
