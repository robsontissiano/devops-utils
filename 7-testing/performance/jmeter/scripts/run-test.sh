#!/bin/bash
# JMeter Test Runner Script
# Usage: ./run-test.sh <test-plan.jmx> [users] [duration]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
USERS=${2:-10}
DURATION=${3:-60}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Check if test plan file exists
if [ -z "$1" ]; then
    echo -e "${RED}Error: Test plan file required${NC}"
    echo "Usage: $0 <test-plan.jmx> [users] [duration]"
    exit 1
fi

TEST_PLAN=$1

if [ ! -f "$TEST_PLAN" ]; then
    echo -e "${RED}Error: Test plan file not found: $TEST_PLAN${NC}"
    exit 1
fi

# Check if JMeter is installed
if ! command -v jmeter &> /dev/null; then
    echo -e "${RED}Error: JMeter not found${NC}"
    echo "Please install JMeter: brew install jmeter"
    exit 1
fi

# Create results directory
RESULTS_DIR="results/${TIMESTAMP}"
mkdir -p "$RESULTS_DIR"

echo -e "${GREEN}Starting JMeter Test${NC}"
echo "Test Plan: $TEST_PLAN"
echo "Users: $USERS"
echo "Duration: ${DURATION}s"
echo "Results: $RESULTS_DIR"
echo "----------------------------------------"

# Run JMeter test
jmeter -n \
    -t "$TEST_PLAN" \
    -l "$RESULTS_DIR/results.jtl" \
    -j "$RESULTS_DIR/jmeter.log" \
    -e \
    -o "$RESULTS_DIR/report" \
    -Jusers="$USERS" \
    -Jduration="$DURATION"

# Check if test completed successfully
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Test completed successfully!${NC}"
    echo "HTML Report: $RESULTS_DIR/report/index.html"
    echo ""
    echo "Open report:"
    echo "  open $RESULTS_DIR/report/index.html"
else
    echo -e "${RED}Test failed!${NC}"
    echo "Check logs: $RESULTS_DIR/jmeter.log"
    exit 1
fi

