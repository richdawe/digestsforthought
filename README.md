# Introduction

digestsforthought is a small app to send an e-mail
containing a small selection of tweets from selected Twitter accounts.
If there are some accounts that you want to read regularly,
but can't find amongst the other tweets, you may find this useful.

It's intended to be run daily, e.g.: using AWS Lambda.
You may find it useful for chosing some tweets to read at breakfast.

# Pre-requisites

## Twitter API key

1. Create a Twitter account.
2. Register a Twitter app at [https://apps.twitter.com/].
3. Create a new app.
4. Generate an API key for your new app with read-only permissions.
5. Make a note of your Twitter consumer API key and secret, and the Twitter access key and secret.

## SparkPost

1. Create a SparkPost account [https://app.sparkpost.com/sign-up]
2. Set up a Sending Domain, and verify it.
3. Create an API key with permissions to send a transmission (Transmissions write permission).
4. Make a note of your SparkPost API key.

# Build

    mkdir -p ~/Envs/digestsforthought
    virtualenv ~/Envs/digestsforthought
    source ~/Envs/digestsforthought/bin/activate
    pip install -r requirements.txt

# Configure

    cp config.json.sample config.json
    # Edit config.json

# Run:

    ./digestsforthought

# Running daily using AWS Lambda

TODO

# Licence

Copyright 2017 Richard Dawe

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

