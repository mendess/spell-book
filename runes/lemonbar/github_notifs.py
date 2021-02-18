#!/usr/bin/env python3
import requests
import threading
import subprocess
from sys import argv
import os
import json
import socket

try:
    with open(os.path.expanduser('~/.config/github/api_key')) as key:
        token = key.read().strip()
except:
    exit(0)

endpoint = "https://api.github.com/notifications"
headers = {
    "Authorization": "token " + token,
    "Accept": "application/vnd.github.v3+json"
}
params = {"all": "false"}  # only unread notifications
last_notifs = '/tmp/last_github_notifs'


class Wildcard:
    def __contains__(self, other):
        return True


def at_work_computer():
    return socket.gethostname() == 'kaladesh'


filters = {
    'work': {
        'owners': ['EmituCom'],
        'checks': [at_work_computer]
    },
    'blacklist': {
        'owners': ['cesium'],
        'checks': [lambda: False]
    },
    'else': {
        'owners': Wildcard(),
        'checks': [lambda: not at_work_computer()]
    }
}


def filter(owner):
    for v in filters.values():
        if owner in v['owners']:
            if all([x() for x in v['checks']]):
                return True
            else:
                return False
    return False


def fetch_notifs() -> int:
    raw_response = requests.get(endpoint, headers=headers, params=params)
    if raw_response.status_code == 200:
        response = raw_response.json()
        n_notifications = 0
        with open(last_notifs, 'w') as notifs:
            for notif in response:
                owner, name = notif["repository"]["full_name"].split('/')
                url = notif['url']
                if filter(owner):
                    n_notifications += 1
                    notifs.write(
                        f'[{owner}/{name}] {notif["subject"]["title"]} [{url}]\n'
                    )
        return n_notifications
    return 'Error fetching notifs'


if len(argv) == 1:
    n = fetch_notifs()
    if n != 0:
        print(f'gh[{n}]')
elif argv[1] == 'dmenu':
    # Currently doesn't work as one would expect
    threading.Thread(target=fetch_notifs)
    with open(last_notifs) as notifs:
        subprocess.Popen(
            fr"""
grep -F "$(dmenu -i -l 20 < {last_notifs})" {last_notifs} | \
        sed -E 's/.*\[([^]]+)]$/\\1/' | xargs -L 1 xdg-open
""",
            shell=True
        )
elif argv[1] == 'show':
    n = fetch_notifs()
    if type(n) == str:
        print(n)
    else:
        subprocess.run(
            fr"""cat {last_notifs} | sed -E 's/\[[^]]+\]$//'""", shell=True
        )
