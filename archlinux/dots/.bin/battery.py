def read_file(fname):
    with open(fname, 'r') as f:
        return f.read()


def current_charge():
    current_battery = int(read_file('/sys/class/power_supply/BAT0/charge_now'))
    full_battery = int(read_file('/sys/class/power_supply/BAT0/charge_full'))
    charge = float(current_battery)/float(second_battery)
    return charge


def main():
    if current_charge() < 0.05:
        mem_dump()
        sleep()

if __name__ == '__main__':
    main()
