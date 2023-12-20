FROM ubuntu:22.04

# dependencies for the test phase
RUN apt update; apt -y install jq curl

# run tests
COPY entrypoint.sh /entrypoint.sh
