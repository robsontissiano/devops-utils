#!/bin/bash
# Generate HTML report from existing JTL file
# Usage: ./generate-report.sh <results.jtl> [output-dir]

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo -e "${RED}Error: Results file required${NC}"
    echo "Usage: $0 <results.jtl> [output-dir]"
    exit 1
fi

RESULTS_FILE=$1
OUTPUT_DIR=${2:-"reports/$(date +%Y%m%d_%H%M%S)"}

if [ ! -f "$RESULTS_FILE" ]; then
    echo -e "${RED}Error: Results file not found: $RESULTS_FILE${NC}"
    exit 1
fi

echo -e "${GREEN}Generating report...${NC}"
echo "Input: $RESULTS_FILE"
echo "Output: $OUTPUT_DIR"

jmeter -g "$RESULTS_FILE" -o "$OUTPUT_DIR"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Report generated successfully!${NC}"
    echo "Open: $OUTPUT_DIR/index.html"
else
    echo -e "${RED}Report generation failed!${NC}"
    exit 1
fi

