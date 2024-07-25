# Match Table

The `match_table.py` Python script generates a dictionary to map Sequoia links to CyVerse links. The script loops through sub-folders in the OpenGeoMetadata `edu.arizona` repository, accesses the `geoblacklight.json` file in each sub-folder, and stores the Sequoia link in the dictionary, using the filename as the key.

The script then loops through the CyVerse data dump (CSV file) and searches for a filename that matches each key in the dictionary. Once a match is found, it stores the corresponding CyVerse link to the appropriate key in the dictionary. 

The structure of the dictionary is as follows:

```
"FileName1.zip" {
  "sequoia": "http://sequoia.library.arizona.edu/FileName1.zip",
  "cyverse": "https://data.cyverse.org/FileName1.zip"
},
"FileName2.zip" {
  "sequoia": "http://sequoia.library.arizona.edu/FileName2.zip",
  "cyverse": "https://data.cyverse.org/FileName2.zip"
},
"FileName3.zip" {
  "sequoia": "http://sequoia.library.arizona.edu/FileName3.zip",
  "cyverse": "https://data.cyverse.org/FileName3.zip"
}
```
*Note: fake links and filenames used for demonstration purposes.*

After generating the match table, the table is then written to a JSON file in the `/app/lib/tasks` directory so that it can be leveraged by the `.rake` file.

## Using the Script

If you would like to use the Python script, you must first:

1. Clone the [OpenGeoMetadata edu.arizona repository](https://github.com/OpenGeoMetadata/edu.uarizona) to your machine.
2. Download a copy of the CyVerse data dump CSV file to your machine. The link to this file can be found in the Redmine wiki for the GeoBlacklight project.
3. Modify the `match_table.py` script by changing the paths defined for variables `ogm_files` and `cyverse_file`, to the paths that match their locations on your machine.
4. If you want to print the results of the script, uncomment everything after line 100 in the Python file.

## "Missing" CyVerse Links

Upon initial completion of this task, we realized we had 32 items that did not find matches within CyVerse. After some [discovery work](https://redmine.library.arizona.edu/issues/15846), we determined that some files had been renamed within CyVerse, while others were located in UAiR, and others in Campus Repository. The script has some specific logic statements to check for these 32 "missing" items and update their links accordingly.

  Note that the following 2 items intentionally left out for now, due to filesize (GBs):
    - McCartysLavaFlowField_15cmDTM_2015.zip
    - McCartysLavaFlowField_15cmOrtho_2015.zip
  
  Note that the following 7 items intentionally left out for now, due to not having found matches:
    - Arizona_100kScaleTopoDecollared_1970to1995.tif
    - Arizona_24kScaleTopoDecollared_1970to1995.tif
    - Arizona_250kScaleTopoDecollared_1970to1995.tif
    - Arizona_USGSDOQQImagery_1992.zip
    - China_BuddhistTempleLocations_2006.zip
    - China_TangBuddhistTempleLocations_618to907.zip
    - USA_WildlandFirePerimeters_1937to2017.zip