#!/usr/bin/env bash

command -v jq >/dev/null 2>&1 || { echo >&2 "Program 'jq' required but it is not installed.  
Aborting."; exit 1; }
command -v wget >/dev/null 2>&1 || { echo >&2 "Program 'wget' required but is not installed.  
Aborting."; exit 1; }

IP=`wget -qO- https://ipecho.net/plain`
IPSTACK_APIKEY="2429834f88ef2fa1a9364f74c8292b69"
CITY_NAME=$(wget -qO- "http://api.ipstack.com/${IP}?access_key=${IPSTACK_APIKEY}&format=1" | jq '.city' | sed 's/"//g')

APIKEY="7e366d360f98786b7286d6ee425d5287"
#ZIPCODE="1234"
URL="http://api.openweathermap.org/data/2.5/weather?q=${CITY_NAME}&units=metric&APPID=${APIKEY}"

WEATHER_RESPONSE=$(wget -qO- "${URL}")

WEATHER_CONDITION=$(echo $WEATHER_RESPONSE | jq '.weather[0].main' | sed 's/"//g')
WEATHER_TEMP=$(echo $WEATHER_RESPONSE | jq '.main.temp')

case $WEATHER_CONDITION in
  'Clouds')
    WEATHER_ICON=""
    ;;
  'Rain')
    WEATHER_ICON=""
    ;;
  'Snow')
    WEATHER_ICON=""
    ;;
  *)
    WEATHER_ICON=""
    ;;
esac

echo "${WEATHER_ICON}  ${WEATHER_TEMP}°C"
