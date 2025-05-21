import json
import csv
import sys
import os
import argparse

def json_to_csv(input_file, output_file, truncate_result=None):
    """
    Convert a JSON log file to CSV format.
    Each line of the input file should be a separate JSON object.
    """
    try:
        # First pass: collect all possible field names
        all_fields = set()
        with open(input_file, 'r', encoding='utf-8', errors='replace') as jsonfile:
            for line in jsonfile:
                line = line.strip()
                if not line:
                    continue
                try:
                    data = json.loads(line)
                    all_fields.update(data.keys())
                except json.JSONDecodeError:
                    pass
        
        # Sort fields to have a consistent order, with common fields first
        priority_fields = ['type', 'subtype', 'cost_usd', 'is_error', 'duration_ms', 
                          'duration_api_ms', 'num_turns', 'total_cost', 'session_id']
        
        fieldnames = []
        # Add priority fields first
        for field in priority_fields:
            if field in all_fields:
                fieldnames.append(field)
                all_fields.remove(field)
        
        # Add any remaining fields alphabetically
        fieldnames.extend(sorted(all_fields))
        
        # Add 'result' at the end (it's typically the longest field)
        if 'result' in fieldnames:
            fieldnames.remove('result')
            fieldnames.append('result')
        
        # Second pass: convert to CSV
        with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
            
            line_number = 0
            success_count = 0
            with open(input_file, 'r', encoding='utf-8', errors='replace') as jsonfile:
                for line in jsonfile:
                    line_number += 1
                    line = line.strip()
                    if not line:
                        continue
                        
                    try:
                        data = json.loads(line)
                        
                        # Truncate result if requested
                        if truncate_result and 'result' in data and isinstance(data['result'], str):
                            if len(data['result']) > truncate_result:
                                data['result'] = data['result'][:truncate_result] + '...'
                        
                        # Create a row with all fields
                        row = {field: data.get(field, '') for field in fieldnames}
                        
                        writer.writerow(row)
                        success_count += 1
                        
                    except json.JSONDecodeError as e:
                        print(f"Error parsing JSON at line {line_number}: {e}", file=sys.stderr)
                    except Exception as e:
                        print(f"Error processing line {line_number}: {e}", file=sys.stderr)
            
            print(f"Processed {line_number} lines, successfully converted {success_count} records.")
            return True
            
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return False

def main():
    parser = argparse.ArgumentParser(description='Convert JSON log files to CSV format.')
    parser.add_argument('input_file', nargs='?', default='logs.json', 
                        help='Input JSON file path (default: logs.json)')
    parser.add_argument('output_file', nargs='?', default='logs.csv', 
                        help='Output CSV file path (default: logs.csv)')
    parser.add_argument('--truncate-result', type=int, metavar='LENGTH',
                        help='Truncate the result field to the specified length')
    
    args = parser.parse_args()
    
    print(f"Converting {args.input_file} to {args.output_file}...")
    success = json_to_csv(args.input_file, args.output_file, args.truncate_result)
    
    if success:
        print(f"Conversion complete. Output saved to {args.output_file}")
    else:
        print("Conversion failed.", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
