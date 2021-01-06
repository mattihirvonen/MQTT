

List running docker instances to get CONTAINER_ID:

    docker ps

Copy file or folder from a docker container to the local file system:

    docker cp CONTAINER_ID:/file/path/in/container/file /host/local/path/file

Copy file or folder from the local file system to a docker container

    docker cp /host/local/path/file CONTAINER_ID:/file/path/in/container/file

Exsample:

    docker cp  ca.crt          d362659da5fc:/etc/mosquitto/ca_certificates/
	docker cp  server.crt      d362659da5fc:/etc/mosquitto/certs/
	docker cp  server.key      d362659da5fc:/etc/mosquitto/certs/
	docker cp  setsecure.conf  d362659da5fc:/etc/mosquitto/conf.d/

Note: mosquitto process all (*).conf files in case sensitive
      alphabetical order in "include_dir" ("/etc/mosquitto/conf.d/")

	http://www.steves-internet-guide.com/mossquitto-conf-file/
	https://mosquitto.org/man/mosquitto-conf-5.html
