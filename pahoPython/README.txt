
Test to use python as MQTT client. This python application can run
with python 2 or 3. Application is test driven with Raspberry Pi 1.
Application can run also with ordinary PC. Required external library
is paho-mqtt library, which have to install!

MQTT message broker can be linux docker (several docker instances are
available). Message broker is also available as windows or linux native
application (even in Raspberry Pi version). Most common message brokers
are "mosquitto" and "RabbitMQ".

Install PIP(3) (Raspberry Pi Lite no desktop version,
Raspberry desktop version might already contain PIP):
- sudo apt install python-pip
- sudo apt install python3-pip

Python(2):
- pip install paho-mqtt

Python3:
 - pip3 install paho-mqtt
 
Run:
- python  raspi1mqtt.py
- python3 raspi1mqtt.py
