#!/bin/bash

# analyze.sh - Analyze statistics from logs CSV file
# Usage: ./analyze.sh logs.csv

if [ $# -lt 1 ]; then
  echo "Usage: $0 <csv_file>"
  exit 1
fi

CSV_FILE=$1

echo "Analyzing statistics from $CSV_FILE..."
echo "========================================================"
echo

# Use awk to calculate statistics on numerical columns
# This analyzes cost_usd, duration_ms, duration_api_ms, num_turns, and total_cost
awk -F, '
BEGIN {
  print "VARIABLE            |    SUM     |    MEAN    |    STD     |    MIN     |    MAX     |"
  print "-------------------|------------|------------|------------|------------|------------"
}

# Skip header row
NR > 1 {
  # Extract values, handle potential quoted fields
  gsub(/^"|"$/, "", $3);  # cost_usd
  gsub(/^"|"$/, "", $5);  # duration_ms
  gsub(/^"|"$/, "", $6);  # duration_api_ms
  gsub(/^"|"$/, "", $7);  # num_turns  
  gsub(/^"|"$/, "", $8);  # total_cost
  
  # Store values in arrays
  cost_usd[NR] = $3
  duration_ms[NR] = $5
  duration_api_ms[NR] = $6
  num_turns[NR] = $7
  total_cost[NR] = $8
  
  # Running sums
  sum_cost += $3
  sum_duration_ms += $5
  sum_duration_api_ms += $6
  sum_num_turns += $7
  sum_total_cost += $8
  
  # Track min/max
  if (NR == 2 || $3 < min_cost) min_cost = $3
  if (NR == 2 || $3 > max_cost) max_cost = $3
  
  if (NR == 2 || $5 < min_duration_ms) min_duration_ms = $5
  if (NR == 2 || $5 > max_duration_ms) max_duration_ms = $5
  
  if (NR == 2 || $6 < min_duration_api_ms) min_duration_api_ms = $6
  if (NR == 2 || $6 > max_duration_api_ms) max_duration_api_ms = $6
  
  if (NR == 2 || $7 < min_turns) min_turns = $7
  if (NR == 2 || $7 > max_turns) max_turns = $7
  
  if (NR == 2 || $8 < min_total_cost) min_total_cost = $8
  if (NR == 2 || $8 > max_total_cost) max_total_cost = $8
  
  count++
}

END {
  if (count > 0) {
    # Calculate means
    mean_cost = sum_cost / count
    mean_duration_ms = sum_duration_ms / count
    mean_duration_api_ms = sum_duration_api_ms / count
    mean_num_turns = sum_num_turns / count
    mean_total_cost = sum_total_cost / count
    
    # Calculate standard deviations
    for (i in cost_usd) {
      std_cost += (cost_usd[i] - mean_cost)^2
      std_duration_ms += (duration_ms[i] - mean_duration_ms)^2
      std_duration_api_ms += (duration_api_ms[i] - mean_duration_api_ms)^2
      std_num_turns += (num_turns[i] - mean_num_turns)^2
      std_total_cost += (total_cost[i] - mean_total_cost)^2
    }
    
    std_cost = sqrt(std_cost / count)
    std_duration_ms = sqrt(std_duration_ms / count)
    std_duration_api_ms = sqrt(std_duration_api_ms / count)
    std_num_turns = sqrt(std_num_turns / count)
    std_total_cost = sqrt(std_total_cost / count)
    
    # Convert durations to seconds for readability
    sum_duration_s = sum_duration_ms / 1000
    mean_duration_s = mean_duration_ms / 1000
    std_duration_s = std_duration_ms / 1000
    min_duration_s = min_duration_ms / 1000
    max_duration_s = max_duration_ms / 1000
    
    sum_duration_api_s = sum_duration_api_ms / 1000
    mean_duration_api_s = mean_duration_api_ms / 1000
    std_duration_api_s = std_duration_api_ms / 1000
    min_duration_api_s = min_duration_api_ms / 1000
    max_duration_api_s = max_duration_api_ms / 1000
    
    # Print results with formatting
    printf "%-19s| %10.2f | %10.2f | %10.2f | %10.2f | %10.2f |\n", "cost_usd ($)", sum_cost, mean_cost, std_cost, min_cost, max_cost
    printf "%-19s| %10.2f | %10.2f | %10.2f | %10.2f | %10.2f |\n", "duration (sec)", sum_duration_s, mean_duration_s, std_duration_s, min_duration_s, max_duration_s
    printf "%-19s| %10.2f | %10.2f | %10.2f | %10.2f | %10.2f |\n", "duration_api (sec)", sum_duration_api_s, mean_duration_api_s, std_duration_api_s, min_duration_api_s, max_duration_api_s
    printf "%-19s| %10.0f | %10.1f | %10.1f | %10.0f | %10.0f |\n", "num_turns", sum_num_turns, mean_num_turns, std_num_turns, min_turns, max_turns
    printf "%-19s| %10.2f | %10.2f | %10.2f | %10.2f | %10.2f |\n", "total_cost ($)", sum_total_cost, mean_total_cost, std_total_cost, min_total_cost, max_total_cost
    
    # Calculate additional metrics
    printf "\nADDITIONAL METRICS:\n"
    printf "%-30s: %10.2f\n", "Average cost per turn ($)", sum_cost / sum_num_turns
    printf "%-30s: %10.2f sec\n", "Average time per turn", sum_duration_s / sum_num_turns
    printf "%-30s: %10.2f sec\n", "API overhead per session", (sum_duration_api_s - sum_duration_s) / count

    # Per iteration statistics (one iteration = one line in the CSV)
    printf "\nPER ITERATION METRICS:\n"
    printf "%-19s| %10.2f | %10.2f | %10.2f | %10.2f | %10.2f |\n", "Cost per iter ($)", mean_cost, std_cost, min_cost, max_cost, sum_cost / count
    printf "%-19s| %10.2f | %10.2f | %10.2f | %10.2f | %10.2f |\n", "Time per iter (sec)", mean_duration_s, std_duration_s, min_duration_s, max_duration_s, sum_duration_s / count
    printf "%-19s| %10.1f | %10.1f | %10.0f | %10.0f | %10.1f |\n", "Turns per iter", mean_num_turns, std_num_turns, min_turns, max_turns, sum_num_turns / count
  } else {
    print "No data found in CSV file!"
  }
}' "$CSV_FILE"

echo
echo "========================================================"
echo "Analysis complete. Processed $(tail -n +2 "$CSV_FILE" | wc -l) records."

# Generate a per-iteration breakdown (remove lines with invalid API keys)
echo
echo "PER ITERATION BREAKDOWN (excluding errors):"
echo "========================================================"
echo "ITERATION | COST ($) | TIME (sec) | TURNS | COST/TURN ($) | TIME/TURN (sec)"
echo "----------|----------|------------|-------|---------------|----------------"

awk -F, '
BEGIN { iter = 1 }
NR > 1 && $3 > 0 {  # Skip header and zero-cost entries
  # Extract values, handle potential quoted fields
  gsub(/^"|"$/, "", $3);  # cost_usd
  gsub(/^"|"$/, "", $5);  # duration_ms 
  gsub(/^"|"$/, "", $7);  # num_turns
  
  # Convert ms to seconds
  duration_s = $5 / 1000
  
  # Calculate cost per turn and time per turn
  if ($7 > 0) {
    cost_per_turn = $3 / $7
    time_per_turn = duration_s / $7
  } else {
    cost_per_turn = 0
    time_per_turn = 0
  }
  
  # Print the iteration data
  printf "%9d | %8.2f | %10.2f | %5d | %13.4f | %14.2f\n", iter, $3, duration_s, $7, cost_per_turn, time_per_turn
  
  iter++
}' "$CSV_FILE"