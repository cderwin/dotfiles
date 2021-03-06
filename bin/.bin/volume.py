import subprocess


def get_sinks():
    pactl = subprocess.run('pactl list sinks', shell=True, check=True, stdout=subprocess.PIPE)
    return pactl.stdout.decode()


def get_volumes(sinks):
    for line in sinks.split('\n'):
        if line.strip().startswith('Volume:'):
            left_volume = line.split('/')[1].strip().rstrip('%')
            right_volume = line.split('/')[3].strip().rstrip('%')
            return (int(left_volume), int(right_volume))

    return None


def get_muted(sinks):
    for line in sinks.split('\n'):
        if line.strip().startswith('Mute:'):
            mute = line.strip().split(':')[1].strip()
            if mute == 'yes':
                return True
            
            if mute == 'no':
                return False

    return None


if __name__ == '__main__':
    pactl_output = get_sinks()
    (left_volume, right_volume) = get_volumes(pactl_output)
    output = f'{int((left_volume + right_volume)/2)}%'
    if get_muted(pactl_output):
        print(f'({output})')
    else:
        print(output)
