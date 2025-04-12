#!/usr/bin/env python3

import requests
import sys
from pyquery import PyQuery

ICON_PATH = "./assets/icons/weather/"

weather_icons_paths = {
    "sunnyDay": ICON_PATH + "sunnyDay.png",
    "clearNight": ICON_PATH + "clearNight.png",
    "cloudyFoggyDay": ICON_PATH + "cloudyFoggyDay.png",
    "cloudyFoggyNight": ICON_PATH + "cloudyFoggyNight.png",
    "rainyDay": ICON_PATH + "rainyDay.png",
    "rainyNight": ICON_PATH + "rainyNight.png",
    "snowyIcyDay": ICON_PATH + "snowyIcyDay.png",
    "snowyIcyNight": ICON_PATH + "snowyIcyNight.png",
    "severe": ICON_PATH + "severe.png",
    "default": ICON_PATH + "default.png",
}

def get_location():
    response = requests.get("https://ipinfo.io")
    data = response.json()
    loc = data["loc"].split(",")
    loc_name = data["city"] + ", " + data["country"]
    return float(loc[0]), float(loc[1]), loc_name
  
def main():

    latitude, longitude, location_name = get_location()

    url = f"https://weather.com/en-PH/weather/today/l/{latitude},{longitude}"

    html_data = PyQuery(url=url)

    # current temperature
    temp = html_data("span[data-testid='TemperatureValue']").eq(0).text() + "C"

    # current status phrase
    status = html_data("div[data-testid='wxPhrase']").text()
    status = f"{status[:16]}.." if len(status) > 17 else status

    # status code
    status_code = html_data("#regionHeader").attr("class").split(" ")[2].split("-")[2]

    # status icon
    if status_code in weather_icons_paths:
        icon = weather_icons_paths[status_code]
    else: 
        icon = weather_icons_paths["default"]

    # temperature feels like
    temp_feel = html_data(
        "div[data-testid='FeelsLikeSection'] > span > span[data-testid='TemperatureValue']"
    ).text()
    temp_feel_text = f"Feels like {temp_feel}c"

    # min-max temperature
    temp_min = (
        html_data("div[data-testid='wxData'] > span[data-testid='TemperatureValue']")
        .eq(1)
        .text()
    )
    temp_max = (
        html_data("div[data-testid='wxData'] > span[data-testid='TemperatureValue']")
        .eq(0)
        .text()
    )
    temp_min_max = f"  {temp_min}\t\t  {temp_max}"

    # wind speed
    wind_speed = html_data("span[data-testid='Wind']").text().split("\n")[0]
    wind_text = f"  {wind_speed}"

    # humidity
    humidity = html_data("span[data-testid='PercentageValue']").text()
    humidity_text = f"  {humidity}"

    # visibility
    visibility = html_data("span[data-testid='VisibilityValue']").text()
    visibility_text = f"  {visibility}"

    # air quality index
    air_quality_index = html_data("text[data-testid='DonutChartValue']").text()

    # hourly rain prediction
    prediction = html_data("section[aria-label='Hourly Forecast']")(
        "div[data-testid='SegmentPrecipPercentage'] > span"
    ).text()
    prediction = prediction.replace("Chance of Rain", "")
    prediction = f"\n\n (hourly) {prediction}" if len(prediction) > 0 else prediction

    # Check user options
    if len(sys.argv) != 2:
        print("Error: Argument missing")
        return

    option = sys.argv[1]

    if(option == '--temp'):
        print(temp)
    elif(option =='--location'):
        print(location_name)
    elif(option == '--status'):
        print(status)
    elif(option == '--icon'):
        print(icon)
    elif(option == '--temp-feel-text'):
        print(temp_feel_text)
    elif(option == '--temp-min-max'):
        print(temp_min_max)
    elif(option == '--wind-text'):
        print(wind_text)
    elif(option == '--humidity-text'):
        print(humidity_text)
    elif(option == '--visibility-text'):
        print(visibility_text)
    elif(option == '--air-quality-index'):
        print(air_quality_index)
    elif(option == '--prediction'):
        print(prediction)
    else:
        print("Error: Wrong option")


if __name__ == "__main__":
    main()
