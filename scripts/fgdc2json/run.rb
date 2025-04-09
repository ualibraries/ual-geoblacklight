#!/usr/bin/env ruby
require 'geo_combine'
require 'json'

# Input path (file or directory), defaults to 'fgdc/'
input_path = ARGV[0] || 'fgdc'

# Output directories
gbl1_output_dir     = 'gbl1'
aardvark_output_dir = 'aardvark'
processed_output_dir = 'fgdc/processed'

# Create output directories if they don't exist
[gbl1_output_dir, aardvark_output_dir, processed_output_dir].each do |dir|
  FileUtils.mkdir_p(dir) unless File.directory?(dir)
end

# Determine files to process
files_to_process = []
if File.directory?(input_path)
  files_to_process = Dir.glob(File.join(input_path, '*.xml'))
elsif File.file?(input_path) && input_path.end_with?('.xml')
  files_to_process = [input_path]
end

# Process each file
files_to_process.each do |input_xml_path|
  base_name = File.basename(input_xml_path, '.xml')
  processed_xml_path = File.join(processed_output_dir, File.basename(input_xml_path))

  output_gbl1_json_path     = File.join(gbl1_output_dir,     "#{base_name}.json")
  output_aardvark_json_path = File.join(aardvark_output_dir, "#{base_name}.json")

  # Convert FGDC to GBLv1
  xml_content         = File.read(input_xml_path)
  fgdc_metadata       = GeoCombine::Fgdc.new(xml_content)
  geoblacklight_obj   = fgdc_metadata.to_geoblacklight
  gbl1_metadata       = geoblacklight_obj.metadata
  output_gbl1_json    = JSON.pretty_generate(gbl1_metadata)

  File.write(output_gbl1_json_path, output_gbl1_json)

  # Migrate GBLv1 to Aardvark
  migrator              = GeoCombine::Migrators::V1AardvarkMigrator.new(v1_hash: gbl1_metadata)
  aardvark_metadata     = migrator.run
  output_aardvark_json  = JSON.pretty_generate(aardvark_metadata)

  File.write(output_aardvark_json_path, output_aardvark_json)

  # Move the processed XML file
  FileUtils.mv(input_xml_path, processed_xml_path)
end

# Output summary
puts "Processing complete." unless files_to_process.empty?
if files_to_process.empty?
  puts "No files to process. Provide a valid XML file or directory."
end
