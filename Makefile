# https://component-model.bytecodealliance.org/language-support/python.html

SHELL := bash

ROOT := $(shell pwd -P)

export VIRTUAL_ENV := $(ROOT)/.venv
export PATH := $(VIRTUAL_ENV)/bin:$(PATH)

URI := https://github.com/bytecodealliance/component-docs/raw/main
ADD_WASM := $(URI)/component-model/examples/example-host/add.wasm


test: add
	python3 add.py

clean:
	$(RM) add.wasm
	$(RM) -r add

realclean:: clean
	$(RM) -r $(VIRTUAL_ENV)

add: add.wasm $(VIRTUAL_ENV)
	python3 -m wasmtime.bindgen $< --out-dir $@

add.wasm:
	curl -sL $(ADD_WASM) > $@

PYTHON := $(shell command -v python3)
PYTHON ?= $(shell command -v python)

$(VIRTUAL_ENV):
	$(PYTHON) -m venv $@
	pip install -r requirements.txt
