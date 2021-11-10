#!/usr/bin/env python3
import requests
import threading
import subprocess
import sys
from sys import argv
import os
import socket
import json
from os.path import dirname
from typing import List

try:
    with open(os.path.expanduser('~/.config/github/api_key')) as key:
        token = key.read().strip()
except Exception as e:
    print(e, file=sys.stderr)
    exit(0)

endpoint = "https://api.github.com/notifications"
headers = {
    "Authorization": "token " + token,
    "Accept": "application/vnd.github.v3+json"
}
params = {"all": "false"}  # only unread notifications
LAST_NOTIFS_FILENAME = f'/tmp/{os.getlogin()}/last_github_notifs'
try:
    os.mkdir(dirname(LAST_NOTIFS_FILENAME))
except:
    pass


class Wildcard:
    def __contains__(self, other) -> bool:
        return True


class Notification(dict):
    def __init__(self, owner, name, title, url):
        dict.__init__(self, owner=owner, name=name, title=title, url=url)
        self.owner = owner
        self.name = name
        self.title = title
        self.url = url

    @staticmethod
    def from_dictionary(d) -> 'Notification':
        Notification(**d)

    def toJson(self) -> str:
        return json.dumps(self.__dict__())


try:
    with open(LAST_NOTIFS_FILENAME) as notifs:
        LAST_NOTIFS = {}
        for k, v in json.load(notifs).items():
            LAST_NOTIFS[k] = Notification.from_dictionary(v)
except FileNotFoundError:
    LAST_NOTIFS = {}
except json.decoder.JSONDecodeError:
    LAST_NOTIFS = {}


def at_work_computer() -> bool:
    return os.getlogin() == 'work'


class Filter:
    def __init__(self, owners, checks):
        self.owners = owners
        self.checks = checks


filters = {
    'work': Filter(
        owners=['SpeechifyInc'],
        checks=[at_work_computer]
    ),
    'blacklist': Filter(
        owners=['cesium'],
        checks=[lambda: False]
    ),
    'else': Filter(
        owners=Wildcard(),
        checks=[lambda: not at_work_computer()]
    )
}


def owner_allowed(owner) -> bool:
    for v in filters.values():
        if owner in v.owners:
            return all([x() for x in v.checks])
    return False


def fetch_notifs() -> List[tuple[Notification, bool]]:
    global LAST_NOTIFS

    raw_response = requests.get(endpoint, headers=headers, params=params)
    if raw_response.status_code != 200:
        return 'Error fetching notifs'

    response = raw_response.json()
    notifications = []
    for notif in response:
        owner, name = notif["repository"]["full_name"].split('/')
        if not owner_allowed(owner):
            continue

        notification = Notification(
            owner=owner,
            name=name,
            title=notif["subject"]["title"],
            url=notif['url']
        )
        notifications.append(
            (notification, notification.url not in LAST_NOTIFS)
        )
    LAST_NOTIFS = {n.url: n for n, _ in notifications}
    with open(LAST_NOTIFS_FILENAME, 'w') as notifs:
        json.dump(LAST_NOTIFS, notifs)
    return notifications


if len(argv) == 1:
    notifications = fetch_notifs()
    if type(notifications) != str and len(notifications) != 0:
        print(f'gh[{len(notifications)}]')
        for n, _ in filter(lambda x: x[1], notifications):
            subprocess.run(['notify-send', f'{n.owner}/{n.name}', n.title])

elif argv[1] == 'dmenu':
    # Currently doesn't work as one would expect
    threading.Thread(target=fetch_notifs)
    subprocess.Popen(
        fr"""
grep -F "$(dmenu -i -l 20 < {LAST_NOTIFS_FILENAME})" {LAST_NOTIFS_FILENAME} | \
    sed -E 's/.*\[([^]]+)]$/\\1/' | xargs -L 1 firefox
""",
        shell=True
    )
elif argv[1] == 'show':
    n = fetch_notifs()
    if type(n) == str:
        print(n)
    else:
        subprocess.run(
            fr"""cat {LAST_NOTIFS_FILENAME} | sed -E 's/\[[^]]+\]$//'""",
            shell=True
        )
