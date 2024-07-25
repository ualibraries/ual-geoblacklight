# Please refer to associated match_table.md file for instructions and notes on this Python script.

import os, json, csv

# Define paths to OGM & CyVerse data.
# These values should be changed according to your machine and paths.
ogm_files = r"/Users/your_user/your_path_to/edu.arizona"
cyverse_file = r"/Users/your_user/your_path_to/cyverse_data.csv"

def generate_match_table(ogm_file_path, cyverse_file_path):
  """Generates and returns a table that matches Sequoia metadada links to CyVerse metadata links based on filename."""

  # Create a dictionary for the match table. Key = filename, value = Sequoia and CyVerse links.
  match_table = {}

  # Loop through all sub-folders in OGM's edu.arizona repo to find Sequoia links, and push them to match_table.
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
              # Save the Sequoia filename to a variable (to act as match key).
              match_key = sequoia_link.split('/')[-1]
              # Push the Sequoia link to match_table, leaving cyverse empty for now.
              match_table[match_key] = {'sequoia': sequoia_link, 'cyverse':''}
  
  # Loop through the CSV data from CyVerse dump to find filename matches (from Sequoia) in match_table.
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

# Match up "missing" CyVerse items.
def match_missing_items(match_table):
  """Matches 23 'missing' items from match_table. Some items intentionally left out (of original 32 missing items) due to filesize or unlocated matches."""

  missing_table = {
    "Arizona_AmerIndianReservations_1870.zip": "https://uair.library.arizona.edu/system/files/atlas/download/AIR_1870_0.zip",
    "Arizona_AmerIndianReservations_1880.zip": "https://uair.library.arizona.edu/system/files/atlas/download/AIR_1880.zip",
    "Arizona_AmerIndianReservations_1890.zip": "https://uair.library.arizona.edu/system/files/atlas/download/AIR_1890.zip",
    "Arizona_AmerIndianReservations_1900.zip": "https://uair.library.arizona.edu/system/files/atlas/download/AIR_1900.zip",
    "Arizona_AmerIndianReservations_1910.zip": "https://uair.library.arizona.edu/system/files/atlas/download/AIR_1910.zip",
    "Arizona_AmerIndianReservations_1920.zip": "https://uair.library.arizona.edu/system/files/atlas/download/AIR_1920.zip",
    "Arizona_AmerIndianReservations_1930.zip": "https://uair.library.arizona.edu/system/files/atlas/download/AIR_1930.zip",
    "Arizona_AmerIndianReservations_1940.zip": "https://uair.library.arizona.edu/system/files/atlas/download/AIR_1940.zip",
    "Arizona_AmerIndianReservations_1950.zip": "https://uair.library.arizona.edu/system/files/atlas/download/AIR_1950.zip",
    "Arizona_AmerIndianReservations_1960.zip": "https://uair.library.arizona.edu/system/files/atlas/download/AIR_1960.zip",
    "Arizona_AmerIndianReservations_1970.zip": "https://uair.library.arizona.edu/system/files/atlas/download/AIR_1970.zip",
    "Arizona_AmerIndianReservations_1980.zip": "https://uair.library.arizona.edu/system/files/atlas/download/AIR_1980.zip",
    "Arizona_VoterPrecincts_2018.zip": "https://uair.library.arizona.edu/system/files/atlas/download/Cen_AZ_Proj.zip",
    "Arizona_Wards_1920.zip": "https://uair.library.arizona.edu/system/files/atlas/download/CityWards_1920.zip",
    "Arizona_Wards_1930.zip": "https://uair.library.arizona.edu/system/files/atlas/download/CityWards_1930.zip",
    "Arizona_Wards_1940.zip": "https://uair.library.arizona.edu/system/files/atlas/download/CityWards_1940.zip",
    "Arizona_Wards_1950.zip": "https://uair.library.arizona.edu/system/files/atlas/download/CityWards_1950.zip",
    "CabezaPrietaNWR_FieldWorkRoutes_2004.zip": "https://repository.arizona.edu/bitstream/handle/10150/146035/routes.shp.shp.zip?sequence=3&isAllowed=y",
    "CabezaPrietaNWR_Vegetation_2004.zip": "https://repository.arizona.edu/bitstream/handle/10150/146035/cabezablm.zip?sequence=4&isAllowed=y",
    "UniversityofArizona_2ftOrthophotos_2001.zip": "https://data.cyverse.org/dav-anon/iplant/commons/community_released//ual/public/University_of_Arizona/Orthophoto/2ftOrthophoto/2001/UniversityofArizona_2ftOrthophotos_2001.tif",
    "UniversityofArizona_5ftOrthophotos_2001.zip": "https://data.cyverse.org/dav-anon/iplant/commons/community_released//ual/public/University_of_Arizona/Orthophoto/5ftOrthophotos/2001/UniversityofArizona_5ftOrthophotos_2001.tif",
    "UniversityofArizona_6inchOrthophotos_1996.zip": "https://data.cyverse.org/dav-anon/iplant/commons/community_released//ual/public/University_of_Arizona/Orthophoto/6inchOrthophoto/1996/UniversityofArizona_6inchOrthophotos_1996.tif",
    "UniversityofArizona_6inchOrthophotos_2001.zip": "https://data.cyverse.org/dav-anon/iplant/commons/community_released//ual/public/University_of_Arizona/Orthophoto/6inchOrthophoto/2001/UniversityofArizona_6inchOrthophotos_2001.tif"
  }

  for key, value in missing_table.items():
    match_table[key]['cyverse'] = value
  
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


def write_match_table(match_table):
  """Writes the contents from generate_match_table() to a JSON file."""

  with open("app/lib/tasks/match_table.json", "w") as matchtable: 
    json.dump(match_table, matchtable)


# Save the results of generate_match_table() and generate_stats to variables.
match_table = generate_match_table(ogm_files, cyverse_file)
match_table_stats = generate_stats(match_table)
match_table = match_missing_items(match_table)

# Write the results to a JSON file for use in the /app/lib/tasks folder (to be used by .rake file).
write_match_table(match_table)

# Print match_table and match_table_stats. Uncomment lines 101-107 to use them.
# print("\n" + "-"*10 + " MATCH TABLE STATS " + "-"*10)
# print_stats(match_table_stats)
# print("-"*39)

# print("\n" + "-"*45 + " MATCH TABLE " + "-"*45)
# print_match_table(match_table)
# print("-"*103)