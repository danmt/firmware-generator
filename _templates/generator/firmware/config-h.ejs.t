---
to: ./<%= name %>/project/src/config.h
---

#ifndef CONFIG_H
#define CONFIG_H

extern const char *DEVICE_ID;
extern const char *DEVICE_USER;
extern const char *DEVICE_PASSWORD;
extern const char *WIFI_SSID;
extern const char *WIFI_PASSWORD;
extern const char *MQTT_SERVER;
extern const int MQTT_PORT;
extern const char *MQTT_WILL_TOPIC;
extern const char *MQTT_WILL_MESSAGE;
extern const int MQTT_WILL_QOS;
extern const bool MQTT_WILL_RETAIN;
extern const bool MQTT_CLEAN_SESSION;
extern const char *DEVICE_TOGGLE_TOPIC;
extern const char *DEVICE_TOGGLED_TOPIC;
extern const char *DEVICE_CONNECTED_TOPIC;
extern const char *DEVICE_RECONNECTED_TOPIC;

#endif