# How to set up GeoServer and Gob together (for now, WIP)

See Redmine ticket [15419](https://redmine.library.arizona.edu/issues/15419) for way-too-many details, all boiled down to the following sequence of events:

1. Start up the Docker orchestration with the startup command `./start-me-up.sh geoserver`
2. Wait for a full startup sequence, then run the following command to load Solr fixtures: `docker exec -it gob-app bash -c -l './rake_command.sh "ual_docs:load"'`
3. Login to [GeoServer](http://gobapp.localhost:8881/geoserver) to see your admin interface. `User = "admin", pass = "geoserver"`
4. Create a new workspace, `UniversityLibrary`, Default workspace, enable all services (WCS, etc.), check Settings Enabled.
5. Add a new store, name it anything, assign it the database creds from the above Redmine ticket.
6. Add a new layer under the UniversityLibrary namespace, publish something like `UniversityLibrary:arizona_mediandatefirstsnowfall_1961to1990` layer to make it available to the GOB. 
7. Visit the GOB instance at `http://gobapp.localhost:3000/catalog/uarizona-arizona-mediandatefirstsnowfall-1961to1990` to see the layer.