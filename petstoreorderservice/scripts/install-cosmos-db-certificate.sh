#!/usr/bin/env bash

EMULATOR_CERT_FILE=cosmos_emulator.cert

# extract ssl certificate into a file
curl -k https://localhost:8084/_explorer/emulator.pem > ${EMULATOR_CERT_FILE}

echo "Deleting cosmosdb alias..."
keytool -delete -v -keystore $JAVA_HOME/lib/security/cacerts -alias cosmosdb -storepass changeit -noprompt
echo "Importing certificate..."
keytool -importcert -file ${EMULATOR_CERT_FILE} -v -keystore $JAVA_HOME/lib/security/cacerts -alias cosmosdb -storepass changeit -noprompt
echo "Listing certificate..."
keytool -list -v -keystore $JAVA_HOME/lib/security/cacerts -alias cosmosdb -storepass changeit -noprompt
rm -Rf ${EMULATOR_CERT_FILE}
