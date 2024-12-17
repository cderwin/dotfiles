#!/usr/bin/env python3

from docopt import docopt
import sys


USAGE = '''Sets macbook pro keyboard backlight.

Usage:
  kbdlight.py increment [--raw] <value>
  kbdlight.py decrement [--raw] <value>
  kbdlight.py set [--raw] <value>
  kbdlight.py get [--raw]
  kbdlight.py (-h | --help)

Options:
  -h, --help  Show this usage.
  --raw       Raw (non-scaled) brightness value'''


BRIGHTNESS_FILE = '/sys/class/leds/smc::kbd_backlight/brightness'
MAX_BRIGHTNESS_FILE = '/sys/class/leds/smc::kbd_backlight/max_brightness'


def get_max_brightness(max_brightness_fname):
    with open(max_brightness_fname) as f:
        str_value = f.read()

    return int(str_value.strip())


def get_brightness(brightness_file):
    with open(brightness_file) as f:
        str_value = f.read()

    return int(str_value.strip())


def set_brightness(brightness, brightness_file, max_brightness):
    if brightness < 0:
        brightness = 0
    elif brightness > max_brightness:
        brightness = max_brightness

    with open(brightness_file, 'w') as f:
        f.write(str(brightness))


def get_raw_value(value, raw, max_brightness):
    if raw:
        return int(value)

    value = float(value) * 0.01 * float(max_brightness)
    return int(value)


def main():
    args = docopt(USAGE)

    brightness = get_brightness(BRIGHTNESS_FILE)
    max_brightness = get_max_brightness(MAX_BRIGHTNESS_FILE)

    if args['increment']:
        delta = get_raw_value(args['<value>'], args['--raw'], max_brightness)
        value = brightness + delta
        set_brightness(value, BRIGHTNESS_FILE, max_brightness)
        return

    if args['decrement']:
        delta = get_raw_value(args['<value>'], args['--raw'], max_brightness)
        value = brightness - delta
        set_brightness(value, BRIGHTNESS_FILE, max_brightness)
        return

    if args['set']:
        value = get_raw_value(args['<value>'], args['--raw'], max_brightness)
        set_brightness(value, BRIGHTNESS_FILE, max_brightness)
        return

    if args['get']:
        if args['--raw']:
            print(brightness)
            return

        percent = 100.0 * float(brightness) / float(max_brightness)
        print(int(percent))
        return

    print('Invalid command.  Run `kbdlight.py -h` to see usage information.')
    sys.exit(1)


if __name__ == '__main__':
    main()
