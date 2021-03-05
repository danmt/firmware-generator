---
to: ./src/<%= name %>/wifi.cpp
---

#include <WiFi.h>
#include <wifi.h>

WiFiConnection::WiFiConnection(const char *SSID, const char *PASSWORD)
{
  ssid = SSID;
  password = PASSWORD;
  WiFiClient client;
}

void WiFiConnection::connect()
{
  int count = 0;
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
    count++;
    if (count > 15)
      ESP.restart();
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}