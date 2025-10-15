from docopt import docopt

USAGE = '''Test.

Usage:
    test.py [options] foo <arg>
    test.py [options] bar <arg>
    test.py [-h | --help]

OptionsL
  -h, --help  Print this usage.'''

args = docopt(USAGE)
print(args)
