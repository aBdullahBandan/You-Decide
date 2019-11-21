# YouDecide

YouDecide is an app that allow users to a pin in any location in the map and will save the pin locally, and show Location and Weather informations and Photos.

## Features:

- Main Screen:
   - Search for a place on the map and once found you can long press to add pins and it will save it automaticlly.
   - Click **Delete** and alert will show up and press **Ok**, click on pins to delete them, once done, click done.

- Photo Album Screen:
   - It will show the photos for the location. and it will save it locally.
   - Click **Reload Photo** to load new set of images.
   - Click on any images to delete it.
- Geo Screen:
   - It will show the information for the location.
- Weather Screen:
   - It will show the the weather information for the location, and it will save it locally.
   - It show the Weather information for the next 7 days, and always will update the information if the saved data not today.
   - Click Reload Weather to load new weather information.
## Libraries:

- Alamofire: used for Load Weather.
- SwiftSky: used alamofire to load Weather.

## APIs:

- Flicker: for Photos.
- DarkSky: for Weathers.
- OpenCage Geocoding: for location information.

## Build:
- Project is build with Xcode Version 11.2.1 (11B500)
