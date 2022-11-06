while true
do
    wget -qO- http://localhost:8080 &> /dev/null
    echo donez
    sleep 0.0005
done