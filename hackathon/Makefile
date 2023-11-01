SHELL := /usr/bin/env bash
GCP_PROJECT := 	wf-gcp-us-eatingsoftware-sbx
REPO_ROOT := $(shell git rev-parse --show-toplevel)

DATA_PATH := data/commit_history.csv

#* Setup
.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))

.DEFAULT_GOAL := help

help: ## help menu
	@echo ${MAKEFILE_LIST}
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# commands

vgpt-init: ## init vgpt
	python -m pip install vgpt
	vgpt --config

auth: ## setup gcp configuration
	echo "run 'gcloud auth' first"
	gcloud config set project ${GCP_PROEJCT}
	gcloud auth application-default login

init: vgpt-init auth ## init gcp and vgpt

gitbot: ## ask
	@${REPO_ROOT}/vgpt/ask.sh "$(ARG)" "${REPO_ROOT}/${DATA_PATH}"
