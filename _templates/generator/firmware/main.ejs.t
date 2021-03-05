---
to: ./src/<%= name %>/main.cpp
---

#include <Arduino.h>
#include <PubSubClient.h>
#include <WiFi.h>
#include <config.h>
#include <wifi.h>
#include <mqtt.h>

WiFiConnection wifiConnection(WIFI_SSID, WIFI_PASSWORD);
WiFiClient espClient;
PubSubClient client(espClient);
MqttConnection mqttConnection(client, MQTT_SERVER, MQTT_PORT);

void setup()
{
  Serial.begin(115200);
  pinMode(BUILTIN_LED, OUTPUT); // make this dynamic
  wifiConnection.connect();
  mqttConnection.connect();
}

void loop()
{
  mqttConnection.loop();
}
