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


## Using the Script

If you would like to use the Python script, you must first:

1. Clone the [OpenGeoMetadata edu.arizona repository](https://github.com/OpenGeoMetadata/edu.uarizona) to your machine.
2. Download a copy of the CyVerse data dump CSV file to your machine. The link to this file can be found in the Redmine wiki for the GeoBlacklight project.
3. Modify the `match_table.py` script by changing the paths defined for variables `ogm_files` and `cyverse_file`, to the paths that match their locations on your machine.
4. If you want to print the results of the script, uncomment everything after line 100 in the Python file.