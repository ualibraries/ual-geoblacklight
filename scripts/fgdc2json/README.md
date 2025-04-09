# scripts/fgdc2aardvark

Converts FGDC XML metadata into Aardvark JSON using GeoCombine for use with GeoBlacklight/Solr.

- **Converts** `FGDC XML` → `GeoBlacklight v1`:
  - Input `.xml` files are moved from `fgdc/` to `fgdc/processed/`
  - Output `.json` files are created in `gbl1/`
- **Migrates** `GeoBlacklight v1` → `Aardvark`:
  - Output `.json` files are created in `aardvark/`

## Getting Started

- Place `FGDC XML` files to be processed in the `scripts/fgdc2json/fgdc` directory
  - ([scripts/zip2xml](../zip2xml/README.md) can be used to extract `.xml` files from `.zip` archives)

### Option 1: Using Lando (Recommended)

```sh
# Start Lando containers
lando start

# Run script
lando fgdc2json
```

### Option 2: Single file via container shell

```sh
# Attach to shell
lando ssh

# Navigate to folder
www-data@9a8b219b260d:/app$ cd scripts/

# Upgrade a single file
ruby run.rb fgdc/your_file_name.xml
```

## Troubleshooting

### JSON Parsing errors

Example during process of `FGDC` → `GBL1`:

```sh
`parse': unexpected token at ..."solr_year_i": unkn}' (JSON::ParserError) JSON::ParserError
```

The value should be a number (`YYYY`) but is being parsed as a string.
Often due to non-numeric content in the source XML.

#### Review Crosswalks

- Review field mapping for `FGDC XML` → `GeoBlacklight v1`:
  - [OGM/Reference/Crosswalks/GBL 1.0 to FGDC and ISO](https://opengeometadata.org/gbl1-fgdc-iso-crosswalk/)

#### Edit the Source FGDC XML

- Locate the corresponding field in the source `FGDC XML` file
  - Example: `solr_year_i` → `.../sngdate/caldate`
- Ensure the value in the XML element is valid
  - Example: `YYYY`

Example of problematic XML:

```xml
				<sngdate>
					<caldate>unknown</caldate>
				</sngdate>
```

- Replace invalid values (like `unknown`) with a valid year (e.g., `1900` if the actual year is unknown)
- After editing the XML, move it back to the `fgdc/` directory and rerun the script

## References

- https://github.com/OpenGeoMetadata/GeoCombine
- https://github.com/OpenGeoMetadata/GeoCombine/blob/main/lib/xslt/fgdc2geoBL.xsl
- https://opengeometadata.org/JSON-format/
- https://opengeometadata.org/ogm-aardvark
- https://opengeometadata.org/gbl1-fgdc-iso-crosswalk/
- https://opengeometadata.org/aardvark-gbl-1-crosswalk/
- https://opengeometadata.org/aardvark-fgdc-iso-crosswalk/
- https://geoblacklight.org/docs/metadata/
- https://github.com/geoblacklight/geoblacklight/blob/main/schema/geoblacklight-schema-aardvark.json
