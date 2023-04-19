if [[ ! -f minigeth ]]; then
    SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
    sudo docker run --rm -v $SCRIPTPATH:/riscvgo -v $SCRIPTPATH/../minigeth:/minigeth --name go1.19 -it golang:1.19 bash /riscvgo/build.sh
fi

if [[ ! -d venv ]]; then
    python3 -m venv venv
    source venv/bin/activate
    pip3 install -r requirements.txt
    deactivate
fi


source venv/bin/activate
python ./compile.py
deactivate
