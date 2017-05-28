Build:

    mkdir -p ~/Envs/digestsforthought
    virtualenv ~/Envs/digestsforthought
    source ~/Envs/digestsforthought/bin/activate
    pip install -r requirements.txt

Configure:

    cp config.json.sample config.json
    # Edit config.json

Run:

    ./digestsforthought

