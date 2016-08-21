#!/usr/bin/env bash

BASEURL="https://archive.mozilla.org/pub/firefox/nightly"
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
VERSION="51.0a1"
LOCALE="en-US"
ARCH="linux-x86_64"
BASE_FILENAME="firefox-$VERSION.$LOCALE.$ARCH"
TARBZ="$BASE_FILENAME.tar.bz2"

TS=$(curl -s $BASEURL/$YEAR/$MONTH/ | sed -ne "s/.*$YEAR-$MONTH-$DAY-\(..-..-..\)-mozilla-central\/.*/\\1/p" | head -n 1)

if [[ -z $TS ]]; then
  # Maybe today's build isn't ready, try yesterday's
  ORIG_YEAR=$YEAR
  ORIG_MONTH=$MONTH
  ORIG_DAY=$DAY
  YEAR=$(date --date=yesterday +%Y)
  MONTH=$(date --date=yesterday +%m)
  DAY=$(date --date=yesterday +%d)
  echo "Can't find build for today, trying yesterday" >&2

  TS=$(curl -s $BASEURL/$YEAR/$MONTH/ | sed -ne "s/.*$YEAR-$MONTH-$DAY-\(..-..-..\)-mozilla-central\/.*/\\1/p" | head -n 1)

  if [[ -z $TS ]]; then
   echo "Couldn't find mozilla-central build for $ORIG_YEAR-$ORIG_MONTH-$ORIG_DAY or $YEAR-$MONTH-$DAY at $BASEURL/"
   exit 1
 fi
fi

DIRURL="$BASEURL/$YEAR/$MONTH/$YEAR-$MONTH-$DAY-$TS-mozilla-central"
SHA512=$(curl -s $DIRURL/$BASE_FILENAME.checksums | grep sha512 | grep "$TARBZ$" | cut -d ' ' -f 1-1)

echo "{
  version = \"$VERSION\";
  sources = [
    {
      locale = \"$LOCALE\";
      arch = \"$ARCH\";
      url = \"$DIRURL/$TARBZ\";
      sha512 = \"$SHA512\";
    }
  ];
}"
