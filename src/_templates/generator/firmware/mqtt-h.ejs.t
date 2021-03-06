---
to: ./src/mqtt.h
---

#ifndef MQTT_H
#define MQTT_H

#include <PubSubClient.h>
#include <config.h>
#include <ArduinoJson.h>

class MqttConnection
{
private:
  const char *server;
  int port;
  PubSubClient *client;
  void callback(char *topic, byte *payload, unsigned int length);
  void reconnect();

public:
  MqttConnection(PubSubClient &client, const char *server, int port);
  void connect();
  void loop();
};

#endif