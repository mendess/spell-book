#!/bin/bash

alias pkubectl='HTTPS_PROXY=socks5://127.0.0.1:1234 kubectl'
alias k8-setns='pkubectl config set-context --current --namespace'
