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

This project is managed using [Pipenv](https://pipenv.readthedocs.io/en/latest/). You will likely need to [install Pipenv](https://pipenv.readthedocs.io/en/latest/install/#installing-pipenv) first.

Once pipenv is installed, you can install all the pre-requisites and start a shell in a Python virtualenv using the following steps. The Python virtualenv makes development easier by using a version of Python set up with all the pre-requiste modules and tools:

```
pipenv install --dev
pipenv shell
```

The pipenv setup includes the AWS command-line tool. If you exit the pipenv shell, you can always restart it using `pipenv shell`.

# Configure

    cp config.json.sample config.json
    # Edit config.json

digestsforthought defaults to using SparkPost US. If you would like to use SparkPost EU, make sure that your `config.json` file contains the following line:

    "sparkpost_base_uri": "https://api.eu.sparkpost.com",

# Run:

    ./digestsforthought

# Running daily using AWS Lambda

TODO

TODO: Note that the commands below fail because cloudformation does not support
the Zipfile property on Lambda. Need to upload the CFN template and ZIP
to S3, then use them in CFN template.

TODO: Parameterise bucket name, since they need to be globally unique

    aws s3 mb s3://digestsforthought
    aws s3 cp cfn/digestsforthought.yaml s3://digestsforthought
    aws s3 cp digestsforthought.zip s3://digestsforthought

    aws cloudformation create-stack --stack-name digestsforthought2 --template-body "$(cat cfn/digestsforthought.yaml)" --parameters ParameterKey=FunctionName,ParameterValue=digestsforthought2 --capabilities CAPABILITY_IAM
    aws cloudformation wait stack-create-complete --stack-name digestsforthought2

    aws cloudformation update-stack --stack-name digestsforthought2 --template-body "$(cat cfn/digestsforthought.yaml)" --parameters ParameterKey=FunctionName,ParameterValue=digestsforthought2 --capabilities CAPABILITY_IAM

# Licence

Copyright 2017-2019 Richard Dawe

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

