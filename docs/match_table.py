# Please refer to associated match_table.md file for instructions and notes on this Python script.

import os, json, csv

# Define paths to OGM & CyVerse data.
# These values should be changed according to your machine and paths.
ogm_files = r"/Users/slaya/Desktop/_git/lbry/OGM_edu.arizona"
cyverse_file = r"/Users/slaya/Desktop/OGM Match Table/cyverse_data.csv"

def generate_match_table(ogm_file_path, cyverse_file_path):
  """Generates and returns a table that matches Sequoia metadada links to CyVerse metadata links based on filename."""

  # Create a dictionary for the match table. Key = filename, value = Sequoia and CyVerse links.
  match_table = {}

  # Loop through all sub-folders in OGM's edu.arizona repo.
  for (root, dirs, files) in os.walk(ogm_files):
    for file in files:
      # Open the geoblacklight.json file so we can access metadata.
      if file == "geoblacklight.json":
        # Save the full file path (including root).
        file_path = os.path.join(root, file)

        # Read in json data from file.
        with open(file_path, 'r') as this_file:
          json_data = this_file.read()
          geo_data = json.loads(json_data)  

          # Loop through keys.               
          for key, value in geo_data.items(): 
            # Access the value at dct_references_s key.
            if key == "dct_references_s":
              sequoia_data = json.loads(value)
              # Save the Sequoia link to a variable & clean up the link.
              sequoia_link = sequoia_data["http://schema.org/downloadUrl"]
              sequoia_link = sequoia_link.replace("?ticket=publicAccess", '')
              sequoia_link = sequoia_link.replace("?publicAccess", '')
              # Save the Sequoia filename to a variable (to act as match key), and clean up the filename.
              match_key = sequoia_link.split('/')[-1]
              match_key = match_key.replace("?ticket=publicAccess", '')
              match_key = match_key.replace("?publicAccess", '')
              # Push the Sequoia link to match_table, leaving cyverse empty for now.
              match_table[match_key] = {'sequoia': sequoia_link, 'cyverse':''}
  
  # Loop through the CSV data from CyVerse dump.
  with open(cyverse_file, 'r') as cyverse:
    cyverse_data = csv.reader(cyverse)
    for row in cyverse_data:
      # Skip all rows except where Type = File.
      if(row[0] == "File"):
        current_file = row[3]
        # Loop through match_table and see if there's a matching filename to current_file.
        for key, value in match_table.items():
          # If match found, push the WebDAV Link (CyVerse link) to match_table.
          if current_file in key:
            match_table[current_file]['cyverse'] = row[6]

  return match_table


def generate_stats(match_table):
  """Generates and returns stats of the match table generated in generate_match_table()."""

  total_entries = len(match_table)
  total_matches = 0
  total_empty_matches = 0 

  for key, value in match_table.items():
    if(value['cyverse'] == ''):
      total_empty_matches+= 1
    else: 
      total_matches+= 1
  
  return {"total": str(total_entries), "matches": str(total_matches), "empty": str(total_empty_matches)}


def print_match_table(match_table):
  """Prints out the contents of the match table generated in generate_match_table()."""

  space = ' '
  for key, value in match_table.items():
    print(key + ": {\n")
    for item, link in value.items():
      print(space*5 + item + ': ' + link)
    print("\n}")


def print_stats(match_table_stats):
  """Prints out the stats generated in generate_stats()."""

  print("Total Entries: " + match_table_stats["total"])
  print("Matched Entries: " + match_table_stats["matches"])
  print("Empty Entries: " + match_table_stats["empty"])


# Save the results of generate_match_table() and generate_stats to variables.
match_table = generate_match_table(ogm_files, cyverse_file)
match_table_stats = generate_stats(match_table)

# Print match_table and match_table_stats. Uncomment lines 101-107 to use them.
# print("\n" + "-"*10 + " MATCH TABLE STATS " + "-"*10)
# print_stats(match_table_stats)
# print("-"*39)

# print("\n" + "-"*45 + " MATCH TABLE " + "-"*45)
# print_match_table(match_table)
# print("-"*103)