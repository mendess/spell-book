#!/usr/bin/env python3
from sys import argv
from typing import List
import re
import subprocess
import os

PERCENTS = re.compile(r'^%%', flags=re.M)
SWITCH_REGEX = re.compile(r'^(switch on ([A-Za-z]\w*))')
CASE_REGEX = re.compile(r'^((\w+)\s*{[ \t]*)')
CASE_END_REGEX = re.compile(r'%%\s*}')
DEFAULT_REGEX = re.compile(r'^(default\s*{)')
SWITCH_END_REGEX = re.compile(r'^(\s*end[^ \t]*)')
ENDLINE = re.compile(r'\s*\n')

def dbg(s):
    print(f"DEBUG: '{s}'")
    return s


def hostname():
    return (
            subprocess
            .run(['hostname'], capture_output=True)
            .stdout
            .decode('utf-8')
            .strip()
        )

class ParseError(Exception):
    def __init__(self, s, message='does not match'):
        super().__init__(f'String "{s[:20]}..." {message}')
        self.s = s


class Unit:
    pass

UNIT = Unit()


class Part:
    def write(self, stream):
        raise NotImplementedError('Not overriden')


class Text(Part):
    def __init__(self, text):
        self.text = text

    def write(self, stream):
        stream.write(self.text)


class Switch:
    def __init__(self, on):
        self.on = on


class Case:
    def __init__(self, case, content):
        self.case = case
        self.content = content


class SwitchCase(Part):
    def __init__(self, switch: Switch, cases: List[Case], default: str = None):
        self.switch = switch
        self.cases = cases
        self.default = default

    def write(self, stream):
        value = reflect_call(self.switch.on)
        for c in self.cases:
            if value == c.case:
                stream.write(c.content)
                return
        if self.default: stream.write(self.default)


def reflect_call(method_name: str) -> str:
    possibles = globals().copy()
    possibles.update(locals())
    method = possibles.get(method_name)
    if not method:
         raise NotImplementedError("Method %s not implemented" % method_name)
    return method()


def parse_whitespace(s: str) -> (Unit, str):
    return (UNIT, s.lstrip())


def parse_endline(s: str) -> (Unit, str):
    match = ENDLINE.search(s)
    if match and match.start() == 0:
        return (UNIT, s[match.end():])
    else:
        raise ParseError(s, 'is not and end of line')


def parse_percents(original_s: str) -> (Unit, str):
    if PERCENTS.match(original_s):
        return (UNIT, original_s[2:].lstrip())
    raise ParseError(original_s, 'does not start with %%')


def skip_up_to(token, s: str, match_len=[]) -> (str, str):
    if isinstance(token, str):
        index = s.find(token)
        match_len.append(len(token))
    elif isinstance(token, re.Pattern):
        match = token.search(s)
        if match:
            index = match.start()
            match_len.append(match.end() - match.start())
        else:
            index = -1

    if index == -1:
        raise ParseError(s, f"doesn't contain {token}")
    else:
        return (s[:index], s[index:])


def skip_past(token, s: str) -> (str, str):
    match_len = []
    (b, a) = skip_up_to(token, s, match_len)
    return (b, a[match_len[0]:])


def parse_switch(original_s: str) -> (Switch, str):
    (_, s) = parse_percents(original_s)
    match = SWITCH_REGEX.match(s)
    if match:
        full = match.group(1)
        on = match.group(2)
        (_, s) = parse_endline(s[len(full):])
        return (Switch(on), s)
    raise ParseError(s, "is not a valid switch header")


def parse_case(original_s: str) -> (Case, str):
    (_, s) = parse_percents(original_s)
    if DEFAULT_REGEX.match(s):
        raise ParseError(original_s, 'is a default case')
    match = CASE_REGEX.match(s)
    if match:
        full = match.group(1)
        case = match.group(2)
        s = s[len(full):]
        (text, s) = skip_past(CASE_END_REGEX, s)
        (_, s) = parse_endline(s)
        return (Case(case, text), s)
    else:
        raise ParseError(original_s, "is not a valid case header")


def parse_cases(s: str) -> (List[Case], str):
    cases = []
    try:
        while True:
            (case, s) = parse_case(s)
            cases += [case]
    except ParseError as pe:
        return (cases, s)


def parse_default(original_s: str) -> (str, str):
    try:
        (_, s) = parse_percents(original_s)
        match = DEFAULT_REGEX.match(s)
        if match:
            (default, s) = skip_past(CASE_END_REGEX, s[len(match.group(1)):])
            (_, s) = parse_endline(s)
            return (default, s)
        else:
            raise ParseError(original_s)
    except ParseError as pe:
        return ("", pe.s)


def parse_end_switch(original_s: str) -> (Unit, str):
    (_, s) = parse_percents(original_s)
    match = SWITCH_END_REGEX.match(s)
    if match:
        return (UNIT, s[len(match.group(1)):])
    else:
        raise ParseError(original_s, 'is expected to be the end of a switch')


def parse_switch_case(s: str) -> (SwitchCase, str):
    (switch, s) = parse_switch(s)
    (cases, s) = parse_cases(s)
    (default, s) = parse_default(s)
    (_, s) = parse_end_switch(s)
    return (SwitchCase(switch, cases, default), s)


def parse(s: str) -> List[Part]:
    parts = []
    while len(s) > 0:
        try:
            (text, s) = skip_up_to(PERCENTS, s)
            parts.append(Text(text))
        except:
            parts.append(Text(s))
            break

        try:
            (sc, s) = parse_switch_case(s)
            parts.append(sc)
        except ParseError as pe:
            if len(pe.s) != 0:
                raise pe

    return parts



if len(argv) < 3:
    print(f'Usage: {os.path.basename(__file__)} template target')
else:
    print(f"'{argv[1]}' x-> '{argv[2]}'")
    try:
        with open(argv[1], 'r') as template:
            s = template.read()
            with open(argv[2], 'w') as generated:
                for p in parse(s):
                    p.write(generated)
    except Exception as e:
        print(e)


