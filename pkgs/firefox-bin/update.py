#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python36 python36Packages.beautifulsoup4 python36Packages.requests2

import os
import re
from datetime import datetime, timedelta
from textwrap import dedent, indent

import requests
from bs4 import BeautifulSoup


BASE_URL = 'https://archive.mozilla.org'
BASE_PATH = 'pub/firefox/nightly'


channel_to_dir = {
    'nightly': 'mozilla-central',
    'aurora': 'mozilla-aurora',
}


class NoBuildFoundException(Exception):
    pass


def get_latest_build_for_date(channel, ts):
    for offset in range(7):
        for build in get_potential_builds_for_date(channel, ts):
            try:
                return get_build(build)
            except NoBuildFoundException:
                pass
        ts -= timedelta(days=1)
    raise NoBuildFoundException


def get_potential_builds_for_date(channel, ts):
    res = requests.get(f"{BASE_URL}/{BASE_PATH}/{ts.year}/{ts.month}/")
    res.raise_for_status()
    doc = BeautifulSoup(res.text, 'html.parser')

    potential_builds = []

    for tag in doc.select('a'):
        href = tag.get('href').rstrip('/')
        target = href.split('/')[-1]
        if re.match(rf'^{ts.year}-{ts.month}-{ts.day}-\d\d-\d\d-\d\d-{channel_to_dir[channel]}$', target):
            potential_builds.append(tag['href'])

    return reversed(sorted(potential_builds))


def get_build(href):
    res = requests.get(f"{BASE_URL}/{href}")
    res.raise_for_status()
    doc = BeautifulSoup(res.text, 'html.parser')

    checksum_href = None

    for tag in doc.select('a'):
        href = tag.get('href')
        target = href.split('/')[-1]
        if re.match(r"^firefox-.*?.en-US.linux-x86_64.checksums$", target):
            checksum_href = href

    if checksum_href is None:
        raise NoBuildFoundException()

    return Build.from_checksum_url(checksum_href)


class Build:

    tarball_re = re.compile(r'''
        firefox-
        (?P<version>[\da\.]+)\.
        (?P<locale>\w+-\w+)\.
        (?P<arch>linux-x86_64)
        \.tar\.bz2
    ''', re.X)

    def __init__(self, *, ts, version, sha512, arch, url, locale):
        self.ts = ts
        self.version = version
        self.sha512 = sha512
        self.arch = arch
        self.url = url
        self.locale = locale

    @classmethod
    def from_checksum_url(cls, url):
        dir_name = url.split('/')[-2]
        ts = datetime.strptime(dir_name[:19], '%Y-%m-%d-%H-%M-%S')

        res = requests.get(f'{BASE_URL}{url}')
        res.raise_for_status()

        for line in res.text.split('\n'):
            if not line:
                continue
            hash, type, size, filename = line.split(' ')
            url = f'{BASE_URL}{os.path.dirname(url)}/{filename}'
            if type != 'sha512':
                continue
            match = cls.tarball_re.match(filename)
            if match:
                return cls(ts=ts, sha512=hash, url=url, **match.groupdict())

        raise NoBuildFoundException()

    def __str__(self):
        return dedent(f"""\
            {{
              version = "{self.version}-{self.ts.year}-{self.ts.month}-{self.ts.day}";
              sources = [
                {{
                  locale = "{self.locale}";
                  arch = "{self.arch}";
                  url = "{self.url}";
                  sha512 = "{self.sha512}";
                }}
              ];
            }}\
        """)


nightly = get_latest_build_for_date('nightly', datetime.now())
aurora = get_latest_build_for_date('aurora', datetime.now())

print(dedent(f"""\
    {{
      aurora = {indent(str(aurora), '      ').strip()};

      nightly = {indent(str(nightly), '      ').strip()};
    }}\
"""))
