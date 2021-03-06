---
to: ./src/mqtt.cpp
---

#include <PubSubClient.h>
#include <mqtt.h>
#include <config.h>
#include <ArduinoJson.h>

long lastMessage = millis();
int connectionCounter = 0;

MqttConnection::MqttConnection(PubSubClient &CLIENT, const char *SERVER, const int PORT)
{
  server = SERVER;
  port = PORT;
  client = &CLIENT;
}

void MqttConnection::connect()
{
  using std::placeholders::_1;
  using std::placeholders::_2;
  using std::placeholders::_3;
  client->setServer(server, port);
  client->setCallback(std::bind(&MqttConnection::callback, this, _1, _2, _3));
}

void MqttConnection::callback(char *topic, byte *payload, unsigned int length)
{
  Serial.print("Message received from -> ");
  Serial.println(topic);
  lastMessage = millis();

  if (strcmp(topic, DEVICE_TOGGLE_TOPIC) == 0)
  {
    StaticJsonDocument<256> doc;
    deserializeJson(doc, payload, length);
    int pin = doc["data"]["actorId"];
    bool state = doc["data"]["isActive"];

    if (state == true)
    {
      Serial.println("Turning (PIN: " + String(pin) + ") ON");
      StaticJsonDocument<256> doc;
      doc["pin"] = pin;
      doc["isActive"] = state;
      char output[128];
      serializeJson(doc, output);
      client->publish(DEVICE_TOGGLED_TOPIC, output);
      digitalWrite(pin, HIGH);
    }
    else
    {
      Serial.println("Turning (PIN: " + String(pin) + ") OFF");
      StaticJsonDocument<256> doc;
      doc["pin"] = pin;
      doc["isActive"] = state;
      char output[128];
      serializeJson(doc, output);
      client->publish(DEVICE_TOGGLED_TOPIC, output);
      digitalWrite(pin, LOW);
    }
  }
}

void MqttConnection::reconnect()
{
  while (!client->connected())
  {
    Serial.println("Attempting to reconnect with MQTT Broker");
    String clientId = "esp32_";
    clientId += String(random(0xffff), HEX);

    Serial.println(DEVICE_ID);
    Serial.println(DEVICE_USER);
    Serial.println(DEVICE_PASSWORD);
    Serial.println(MQTT_WILL_TOPIC);
    Serial.println(MQTT_WILL_QOS);
    Serial.println(MQTT_WILL_RETAIN);
    Serial.println(MQTT_WILL_MESSAGE);
    Serial.println(MQTT_CLEAN_SESSION);

    if (
        client->connect(
            DEVICE_ID,
            DEVICE_USER,
            DEVICE_PASSWORD,
            MQTT_WILL_TOPIC,
            MQTT_WILL_QOS,
            MQTT_WILL_RETAIN,
            MQTT_WILL_MESSAGE,
            MQTT_CLEAN_SESSION))
    {
      Serial.println("Device connected");
      client->subscribe(DEVICE_TOGGLE_TOPIC);
      ++connectionCounter;
      if (connectionCounter == 1)
      {
        client->publish(DEVICE_CONNECTED_TOPIC, DEVICE_ID);
      }
      else
      {
        client->publish(DEVICE_RECONNECTED_TOPIC, DEVICE_ID);
      }
    }
    else
    {
      Serial.print("Connection failed: ");
      Serial.print(client->state() + ". ");
      Serial.println("The system will retry in 5 seconds.");

      delay(5000);
    }
  }
}

void MqttConnection::loop()
{
  if (!client->connected())
  {
    reconnect();
  }

  client->loop();
}