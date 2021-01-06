#!/bin/bash
#
# Check: "server.cnf" source file
#
# Ref(s):
# http://www.steves-internet-guide.com/creating-and-using-client-certificates-with-mqtt-and-mosquitto/
# http://www.steves-internet-guide.com/mosquitto-tls/
#
# https://wiki.openssl.org/index.php/Command_Line_Utilities
# https://www.switch.ch/pki/manage/request/csr-openssl/
# https://rietta.com/blog/openssl-generating-rsa-key-from-command/
#

OUTDIR=config

PASSPHRASE_CA_KEY=passphrase
COMMONNAME=mosquitto             # Typically same as server's host name

FQDN=$COMMONNAME                 # Set this name to client's "/etc/hosts" file
SERVERCONF=$OUTDIR/server.conf   # Mosquitto config file in "/etc/mosquitto/conf.d/"

mkConfigFiles () {
	# sudo apt install openssl

	mkdir -p $OUTDIR

	# Step 1:
	# First create a key pair for the CA
	# Give something to pass phrase query!
	# echo $PASSPHRASE_CA_KEY   >tmp.in
	# echo $PASSPHRASE_CA_KEY  >>tmp.in
	   openssl genrsa -des3 -out $OUTDIR/ca.key 2048
	## openssl genrsa       -out $OUTDIR/ca.key 2048

	# Step 2:
	# Now Create a certificate for the CA using the CA key that we created in step 1
	# Common Name is important. Paho library use hosta name same as Common Name!
	# Paho do not accept IP number instead of domain name when using security feature!
	# If required, set valid hostname in client's "/etc/hosts"file
	##  openssl req -new -config server.cnf -keyout server.key -out server.csr
		openssl req -new -config server.cnf -x509 -days 1826 -key $OUTDIR/ca.key -out $OUTDIR/ca.crt
	##  openssl req -new -x509 -days 1826 -key ca.key -out ca.crt

	# Step 3:
	# Now we create a server key pair that will be used by the broker
		openssl genrsa -out $OUTDIR/server.key 2048

	# Step 4:
	# Now we create a certificate request .csr.
	# When filling out the form the common name is important
	# and is usually the domain name of the server.
		openssl req -new -config server.cnf -out $OUTDIR/server.csr -key $OUTDIR/server.key

	# Step 5:
	# Now we use the CA key to verify and sign the server certificate.
	# This creates the server.crt file
		openssl x509 -req -in $OUTDIR/server.csr -CA $OUTDIR/ca.crt -CAkey $OUTDIR/ca.key -CAcreateserial -out $OUTDIR/server.crt -days 360

	# Step 6:
		ls -l $OUTDIR

	# Step 7:
	# Copy the files ca.crt, serever.crt and server.key to a folder
	# under the mosquitto folder. I have used a folder called certs.
	#
	# On Linux you should already have a ca_certificates folder under /etc/mosquitto/
	# and also a certs folder.
	#
	# Use the ca_certificates folder for the CA certificate and
	# the certs folder for the server certificate and key.
	echo .
	echo "Copy  \"ca.crt\", \"server.crt\" and \"server.key\"  files to mosquitto server"

	# Step 8:
	# Copy the CA certificate file  ca.crt  to the client.
	echo .
	echo "Copy  \"ca.crt\"  file to client"

	# Step 9:
	echo ""                                                >$SERVERCONF
	echo "# Port to use the default listener"             >>$SERVERCONF
	echo "port 8883"                                      >>$SERVERCONF
	echo ""                                               >>$SERVERCONF
	echo "# Certificate based SSL/TLS support"            >>$SERVERCONF
	echo "cafile   /etc/mosquitto/ca_certificate/ca.crt"  >>$SERVERCONF
	echo "keyfile  /etc/mosquitto/certs/server.key"       >>$SERVERCONF
	echo "certfile /etc/mosquitto/certs/server.crt"       >>$SERVERCONF
	echo "tls_version  tlsv1"                             >>$SERVERCONF

	# Step 10:
	echo .
	echo " Copy  \"server.conf\" file to mosquitto server"
	echo .
}


installConfig () {
	cp -p  $OUTDIR/ca.crt       /etc/mosquitto/ca_certificates/
	cp -p  $OUTDIR/server.crt   /etc/mosquitto/certs/
	cp -p  $OUTDIR/server.key   /etc/mosquitto/certs/
	cp -p  $SERVERCONF          /etc/mosquitto/conf.d/
}


dockerCp2host () {
	mkdir  -p  $OUTDIR
	docker cp  $1:/etc/mosquitto/ca_certificates/*  $OUTDIR/
	docker cp  $1:/etc/mosquitto/certs/*            $OUTDIR/
	docker cp  $1:/etc/mosquitto/conf.d/*           $OUTDIR/
}


dockerCp2container () {
	docker cp  $OUTDIR/ca.crt      $1:/root/$OUTDIR/
	docker cp  $OUTDIR/server.crt  $1:/root/$OUTDIR/
	docker cp  $OUTDIR/server.key  $1:/root/$OUTDIR/
	docker cp  mkcert.sh           $1:/root/
}


printHelp () {
	echo "Usage:  $1 [mkconfig | install | id | getconfig | putconfig]"
}

case "$1" in

	"mkconfig")
		mkConfigFiles
		;;
	"install")
		installConfig
		;;
	"id")
		docker ps
		;;
	"getconfig")
		dockerCp2host $2
		;;
	"putconfig")
		dockerCp2container $2
		;;
	*)
		printHelp
		;;
esac
