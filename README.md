# OpenWeatherDemo

## Get the Source
    git clone https://github.com/ravrx8/OpenWeatherDemo.git

## Running the App
You should need to change the Team in the target Signing settings.

If running in the simulator then you can simulate locations in the Debug menu of
the simulator.

## Project Structure
    /OpenWeatherDemo
        /Presentation
        /Domain
            /Config
            /Services
            /Models
        /Persistence
        /Repositories
        /Network
        /Framework
    /Resources
    /Frameworks

Key project directories/groups:  
- **Presentation**
    - Contains the views, view controllers, view models and storyboards for _this_ project.
- **Domain**
    - The domain layer contains service facades (only one) and domain models. Other layers of the app shall communicate through (or via interfaces in) the domain layer. This is the "Life Preserver" architecture approach.
- **Network**
    - API clients and networking code goes here.
- **Repositories**
    - For storing/caching content.
- **Persistence**
    - For persisting content.
- **Framework**
    - Contains some shared helper code.

## Known Issues
- Outside of the US the GeoCoder seems unable to reverse geocode. Switching to lat/lon would work for all locations. The plan was to use Apple's GeoCoder to get the city name, but maybe OpenWeather would provide that.
- Didn't have time for unit tests.
- The UI is pretty boring.
