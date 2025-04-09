# scripts/zip2xml

Extracts `.xml` files from `.zip` archives in a directory

## Usage

- Rename `.env.example` to `.env`
- Update `INPUT_DIR` and `OUTPUT_DIR` paths
- Place `.zip` files to be processed in `INPUT_DIR`

```sh
# Run script
./run.sh
```

- Check `OUTPUT_DIR` for results
- Use [scripts/fgdc2json](../fgdc2json/README.md) to transform the metadata
