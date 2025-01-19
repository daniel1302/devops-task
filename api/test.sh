#!/bin/bash
echo "Getting environment";
curl http://localhost:8082/environment

echo "Inserting a few counts";
for i in $(seq 1 1000); do
    curl -X POST "http://localhost:8082/count/$i"; echo;
done

echo "Delete a few counts"
curl -X DELETE "http://localhost:8082/count/1"; echo;
curl -X DELETE "http://localhost:8082/count/1"; echo;
curl -X DELETE "http://localhost:8082/count/1"; echo;
curl -X DELETE "http://localhost:8082/count/1"; echo;
curl -X DELETE "http://localhost:8082/count/2"; echo;
curl -X DELETE "http://localhost:8082/count/2"; echo;
curl -X DELETE "http://localhost:8082/count/3"; echo;