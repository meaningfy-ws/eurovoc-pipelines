docker run --name virtuoso-db \
    -p 8890:8890 -p 1111:1111 \
    -e DBA_PASSWORD=amarkc0023 \
    -e SPARQL_UPDATE=true \
    -e DEFAULT_GRAPH=http://publications.europa.eu/resource \
    -v ~/virtuoso/virtuoso_data:/data \
    -d tenforce/virtuoso
