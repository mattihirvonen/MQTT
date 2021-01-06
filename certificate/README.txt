
Note:
  mosquitto process all (*).conf files in case sensitive
  alphabetical order from "include_dir" ("/etc/mosquitto/conf.d/")

Ref:
  http://www.steves-internet-guide.com/mossquitto-conf-file/
  https://mosquitto.org/man/mosquitto-conf-5.html


mosquitto-cert.sh
=================
Command line tool create and install mosquitto server SSL/TLS keys and configuration

  mosquitto-cert.sh  mkconfig       create certificate and configuration files into "config/" folder
  
  mosquitto-cert.sh  install        copy certificate and configuration files from "config/" folder
                                    to "/etc/mosquitto/*" folders
						 
  mosquitto-cert.sh  id             list running docker container instances and ID(s).
                                    ID required as command line argument when
						            copy config files from/to container's folder(s)
						 
  mosquitto-cert.sh  getconfig ID   copy docker container's mosquitto server's config files
                                    into host's local folder "config/"

  mosquitto-cert.sh  putconfig ID   copy mosquitto server's config files from local host's "config/"
                                    folder into docker container's "/root/config/" folder
						 
=======================================================

List running docker instances to get CONTAINER_ID:

    docker ps

Copy file or folder from a docker container to the local file system:

    docker cp CONTAINER_ID:/file/path/in/container/file /host/local/path/file

Copy file or folder from the local file system to a docker container

    docker cp /host/local/path/file CONTAINER_ID:/file/path/in/container/file

Example:

    docker ps
    docker cp  ca.crt          d362659da5fc:/etc/mosquitto/ca_certificates/
	docker cp  server.crt      d362659da5fc:/etc/mosquitto/certs/
	docker cp  server.key      d362659da5fc:/etc/mosquitto/certs/
	docker cp  setsecure.conf  d362659da5fc:/etc/mosquitto/conf.d/

