# Docker orchestration for UAL GOB (Geoblacklight) development

## Overview

Something to help me learn something about [GeoBlacklight](https://geoblacklight.org/)

## Setup

Build the Docker container:

```shell
$ ./dbuild.sh
```

Start the Docker network:

```shell
$ docker compose up -d
```

Startup can take a while. The container has to deploy a new RoR GOB app and install Solr. This can be sped up by making an image distro. For now, just wait a while before hitting the `destroy` button.

If the container is rebuilt and it is desired to restart the whole stack, remember to delete the `app/ual_geoblacklight` directory that was generated in the container, lest this cause distress later on. Solr will be reinstalled, too.

## Notes

* https://geoblacklight.org/tutorial/2015/02/09/create-your-application.html#install-geoblacklight
* https://github.com/geoblacklight/geoblacklight
* https://github.com/geobtaa/geoportal-solr-config
