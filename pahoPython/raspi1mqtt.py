# Reference(s):
# https://www.digikey.com/en/maker/blogs/2019/how-to-use-mqtt-with-the-raspberry-pi
# https://medium.com/@emqtt/use-mqtt-with-raspberry-pi-70a908fda89d
# http://mqtt-explorer.com/

import paho.mqtt.client as mqtt  # Import the MQTT library
import time                      # The time library is useful for delays

client_name = "makerio_mqtt"
client_name = "homeio_mqtt"

URL   = "test.mosquitto.org"
URL   = "192.168.2.97"
PORT  = 1883                # Default MQTT port is 1883
ALIVE = 600                 # Keep alive time [s]

status = "raspi1/status"
topic0 = "raspi1/number"    # Publish this topic
topic1 = "raspi1/toggle"    # Publish this topic
topic2 = "raspi2/number"    # Subscribe to other client's published topic


# The callback function. It will be triggered when trying to connect to the MQTT broker
# client is the client instance connected this time
# userdata is users' information, usually empty. If it is needed, you can set it through user_data_set function.
# flags save the dictionary of broker response flag.
# rc is the response code.
# Generally, we only need to pay attention to whether the response code is 0.
def connectFunction(client, userdata, flags, rc):
    if rc == 0:
        print("Connected success")
    else:
        print( "Connected fail with code " + str(rc))   # Python 2
    #   print(f"Connected fail with code {rc}")         # Python 3
	#	
    # subscribe, which need to put into on_connect
    # if reconnect after losing the connection with the broker,
	# it will continue to subscribe to the raspberry/topic topic
    #
    client.subscribe(topic1)    # "loop back" own publish!
    client.subscribe(topic2)    # Subscribe to other client's publish

	
# Our "on message" event (==received subscriptions handler)
def messageFunction (client, userdata, msg):
    topic = str(msg.topic)
    message = str(msg.payload.decode("utf-8"))
    print(topic + " = " + message)              # Python 2
#   print(f"{msg.topic} {msg.payload}")         # Python 3


myClient = mqtt.Client(client_name)     # Create a MQTT client object
myClient.on_connect = connectFunction   # Submit the subscriptions at (re)connect
myClient.on_message = messageFunction   # Attach the messageFunction to subscription(s)

# Set the will message, when the Raspberry Pi is powered off,
# or the network is interrupted abnormally,
# it will send the will message to other clients
#myClient.will_set('raspberry/status', b'{"status": "Off"}')
myClient.will_set(status, b'{"status": "Off"}')

myClient.connect(URL, PORT, ALIVE)
#myClient.connect(URL, PORT)            # Connect to the MQTT broker
myClient.loop_start()                   # Start the MQTT client

# Set the network loop blocking,
# it will not actively end the program before
# calling disconnect() or the program crash
# myClient.loop_forever()

# The four parameters are:
# topic, sending content, QoS and whether retaining the message respectively
#myClient.publish('raspberry/status', payload=b'{"status": "On"}', qos=0, retain=False)
myClient.publish(status, payload=b'{"status": "On"}', qos=0, retain=False)
 
# Main program loop
number = 0
while(1):
    number = number + 1
    myClient.publish(topic0, number)    # Publish message to MQTT broker
    myClient.publish(topic1, "on")      # Publish message to MQTT broker
    time.sleep(3)                       # Sleep for some second(s)
    #
    number = number + 1
    myClient.publish(topic0, number)    # Publish message to MQTT broker
    myClient.publish(topic1, "off")     # Publish message to MQTT broker
    time.sleep(3)                       # Sleep for some second(s)
