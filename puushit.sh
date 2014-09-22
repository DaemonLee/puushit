#!/bin/sh

# puushit - A small script designed for integration in minimalist window managers.
# Copyright 2014 Daemon Lee Schmidt

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
IMAGE="/tmp/screeny.png"

import $IMAGE

# Thanks @blha303 for this line! Originally from: https://github.com/blha303/puush-linux
URL=`curl "https://puush.me/api/up" -F "k=$PUUSH_API_KEY" -F "z=z" -F "f=@$IMAGE" 2>/dev/null | sed -E 's/^.+,(.+),.+,.+$/\1/'`

echo -n $URL | xclip -selection clipboard

notify-send -u low "$URL copied to clipboard"

rm $IMAGE