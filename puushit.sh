#!/bin/sh

# puushit - A small script designed for puush.me integration in minimalist window managers.
# Copyright 2015 Daemon Lee Schmidt

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     https://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#PUUSH_API_KEY=""

# flags
CUSTOMIMAGE_FLAG=false

while [[ $# > 1 ]]
do
opts="$1"

case $opts in
  -i|--input)
  IMAGE=$2
  CUSTOMIMAGE_FLAG=true
  shift
  ;;
  -k|--key)
  PUUSH_API_KEY=$2
  shift
  ;;
  *)
  ;;
esac
shift
done

if [ -z ${PUUSH_API_KEY+x} ]; then
  echo "Please enter a Puush API key using -k|--key [KEY] or set PUUSH_API_KEY to it."
  exit 1
fi

if ! $CUSTOMIMAGE_FLAG ; then
  if [ -z ${XDG_CACHE_HOME+x} ]; then IMAGE="$HOME/.cache/puushit-"; else IMAGE="$XDG_CACHE_HOME/puushit-"; fi
  IMAGE+=$(date "+%FT%T")".png"

  eval $(slop)

  if [ "$Cancel" == "true" ]; then
    exit 1
  fi

  import -quality 99 -strip -window root -crop "$G" +repage $IMAGE
fi

# Thanks @blha303 for part of this line! Originally from: https://github.com/blha303/puush-linux
URL=$(curl "https://puush.me/api/up" -F "k=$PUUSH_API_KEY" -F "z=z" -F "f=@$IMAGE" 2>/dev/null | sed -E 's/^.+,(.+),.+,.+$/\1/;0,/http/{s/http/https/}')

echo -n "$URL" | xclip -selection clipboard

notify-send -u low "$URL copied to clipboard"

if  ! $CUSTOMIMAGE_FLAG ; then
  rm $IMAGE
fi
