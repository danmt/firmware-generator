---
to: ./src/wifi.h
---

#ifndef WIFI_H
#define WIFI_H

#include <WiFi.h>

class WiFiConnection
{
private:
  const char *ssid;
  const char *password;

public:
  WiFiClient *client;
  WiFiConnection(const char *ssid, const char *password);
  void connect();
};

#endif