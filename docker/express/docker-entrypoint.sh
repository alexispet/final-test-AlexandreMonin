#!/bin/sh

echo "Exécution du docker-entrypoint"

if [ $NODE_ENV == "development" ]
then
    echo "On est en development"
    npm install
fi

npm run db:import 
 
exec "$@"