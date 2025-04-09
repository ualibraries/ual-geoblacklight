#!/bin/bash

source .env

INPUT_DIR=${INPUT_DIR:-input}
OUTPUT_DIR=${OUTPUT_DIR:-output}

mkdir -p "$OUTPUT_DIR"

for zipfile in input/*.zip; do
  unzip -j "$zipfile" "*.xml" -d "$OUTPUT_DIR"
done
