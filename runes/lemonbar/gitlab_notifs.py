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
    with open(os.path.expanduser('~/.config/gitlab/api-key')) as key:
        token = key.read().strip()
except Exception as e:
    print(e, file=sys.stderr)
    exit(0)

endpoint = "https://gitlab.cfdata.org/api/v4/todos"
headers = { "PRIVATE-TOKEN": token }
# check https://docs.gitlab.com/api/todos/ for more filters
params = {"state": "pending"}  # only unread notifications
LAST_NOTIFS_FILENAME = f'/tmp/{os.getlogin()}/last_gitlab_notifs'
try:
    os.mkdir(dirname(LAST_NOTIFS_FILENAME))
except:
    pass


class Wildcard:
    def __contains__(self, other) -> bool:
        return True


class Notification(dict):
    def __init__(self, name, author, reason, url, title):
        dict.__init__(
            self,
            name=name,
            author=author,
            title=title,
            url=url,
            reason=reason,
        )
        self.name = name
        self.author = author
        self.title = title
        self.url = url
        self.reason = reason

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


def fetch_notifs() -> List[tuple[Notification, bool]]:
    global LAST_NOTIFS

    raw_response = requests.get(endpoint, headers=headers, params=params)
    if raw_response.status_code != 200:
        return 'Error fetching notifs'

    response = raw_response.json()
    notifications = []
    for notif in response:
        notification = Notification(
            name=notif["project"]["name"],
            author=notif["author"]["name"],
            reason=notif["action_name"],
            url=notif['target_url'],
            title=notif["target"]["title"],
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
        print(f'gl[{len(notifications)}]')
        for n, _ in filter(lambda x: x[1], notifications):
            subprocess.run(['notify-send', f'{n.name}', f'{n.title}\n\nreason: {n.reason}\nauthor: {n.author}'])

elif argv[1] == 'dmenu':
    # Currently doesn't work as one would expect
    threading.Thread(target=fetch_notifs)
    subprocess.Popen(
        fr"""
grep -F "$(dmenu -i -l 20 < {LAST_NOTIFS_FILENAME})" {LAST_NOTIFS_FILENAME} | \
    sed -E 's/.*\[([^]]+)]$/\\1/' | xargs -L 1 $BROWSER
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
