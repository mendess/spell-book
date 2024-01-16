#!/bin/bash

price=$(xh GET https://www.alphavantage.co/query \
    function==TIME_SERIES_INTRADAY \
    symbol==NET \
    interval==5min \
    apikey==$(RUST_LOG='' spark ssh mirrodin -- cat alpha-vantage-api-key) |
    jq -r '."Time Series (5min)" | to_entries | .[0].value."1. open"'
)

if [ "$price" ]; then
    printf "CF: %s" $price
fi
