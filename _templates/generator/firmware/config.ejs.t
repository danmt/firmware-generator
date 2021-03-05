---
to: ./src/<%= name %>/config.cpp
---

#include <config.h>

const char *DEVICE_ID = "<%= deviceId %>";
const char *DEVICE_USER = "<%= brokerUser %>";
const char *DEVICE_PASSWORD = "<%= brokerPassword %>";
const char *WIFI_SSID = "<%= networkSsid %>";
const char *WIFI_PASSWORD = "<%= networkPassword %>";
const char *MQTT_SERVER = "<%= brokerServer %>";
const int MQTT_PORT = <%= brokerPort %>;
const char *MQTT_WILL_TOPIC = "devices/<%= deviceId %>/disconnected";
const int MQTT_WILL_QOS = 0;
const bool MQTT_WILL_RETAIN = false;
const bool MQTT_CLEAN_SESSION = false;
const char *MQTT_WILL_MESSAGE = "";
// MQTT topics
const char *DEVICE_TOGGLE_TOPIC = "devices/<%= deviceId %>/toggle";
const char *DEVICE_TOGGLED_TOPIC = "devices/<%= deviceId %>/toggled";
const char *DEVICE_CONNECTED_TOPIC = "devices/<%= deviceId %>/connected";
const char *DEVICE_RECONNECTED_TOPIC = "devices/<%= deviceId %>/reconnected";