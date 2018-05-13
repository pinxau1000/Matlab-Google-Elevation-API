# Matlab-Google-Elevation-API
Matlab Script to get a elevation profile along a path defined between two points with n resolution samples.

![image1](https://raw.githubusercontent.com/pinxau1000/Matlab-Google-Elevation-API/master/Example_Script_1.png)

## How to use?
Just download getElevationsPath.m file from this repository and paste it on the folder of the script that is calling this function.

#### Help
```matlab
GETELEVATIONSPATH queries Google Maps API webservice for ground elevations
along the path between the latitudes and longitues provided with n
resolution samples.

  elevation = getElevationsPath(latitude1, longitude1, latitude2,
  longitude2, resolution, 'key', 'YOUR-API-KEY');
  Returns <resolution> points of elevation from the path from 
  Point1(latitude1, longitude1) to Point2 (latitude2, longitude2).

  [elevation, resolution] = getElevationsPath(latitude1, longitude1, 
  latitude2, longitude2, resolution, 'key', 'YOUR-API-KEY');
  Returns <resolution> points of elevation and resolution from the path
  from Point1(latitude1, longitude1) to Point2 (latitude2, longitude2).

  [elevation, resolution, latitudes, longitudes] = 
  getElevationsPath(latitude1, longitude1, latitude2, longitude2, 
  resolution, 'key', 'YOUR-API-KEY');
  Returns <resolution> points of elevation, resolution, latitudes and
  longitudes from the path from Point1(latitude1, longitude1) to Point2
  (latitude2, longitude2).

------------------------------------------------------------------------
  Example:
                  Get an area profile. Area vertex are:
                      VERTEX            LAT        LONG
                  Up Left Corner:    39.549937, -8.819350
                  Up Right Corner:   39.549937, -8.761150
                  Down Left Corner:  39.505018, -8.819350
                  Down Right Corner: 39.505018, -8.761150

    clearvars;
    clc;

    SAMPLES = 100;
    API_KEY = 'YOUR-API-KEY';   % Read https://developers.google.com/maps/documentation/elevation/get-api-key

    Coord1 = [39.549937, -8.819350];
    Coord2 = [39.505018, -8.761150];

    try
        load(['backup_' num2str(SAMPLES)]);

        % Sucess loaded but the number of samples are different or the
        % coordinates are different. Need to request elevations again.
        if length(lat_map)~=SAMPLES || lat_map(1)~=Coord1(1) || lng_map(1)~=Coord1(2) ...
                || lat_map(length(lat_map),1)~=Coord2(1) || lng_map(1,length(lng_map))~=Coord2(2)

            disp('Requesting Elevations to Google');

            lat = linspace(Coord1(1), Coord2(1), SAMPLES);  %Latitude Points

            % Preallocating memory for speed improvement
            elevation_map = NaN(SAMPLES, SAMPLES);
            resolution_map = NaN(SAMPLES, SAMPLES);
            lat_map = NaN(SAMPLES, SAMPLES);
            lng_map = NaN(SAMPLES, SAMPLES);

            % Gets the area elevations.
            for r=1:length(lat)
                [elevation_map(r,:), resolution_map(r,:), lat_map(r,:), lng_map(r,:)] = getElevationsPath(lat(r), Coord1(2), lat(r), Coord2(2), SAMPLES, 'key', API_KEY);
            end

            save(['backup_' num2str(SAMPLES)], 'elevation_map', 'resolution_map', 'lat_map', 'lng_map');
        end
    catch

        disp('Requesting Elevations to Google');

        lat = linspace(Coord1(1), Coord2(1), SAMPLES);  %Latitude Points

        % Preallocating memory for speed improvement
        elevation_map = NaN(SAMPLES, SAMPLES);
        resolution_map = NaN(SAMPLES, SAMPLES);
        lat_map = NaN(SAMPLES, SAMPLES);
        lng_map = NaN(SAMPLES, SAMPLES);

        % Gets the area elevations.
        for r=1:length(lat)
            [elevation_map(r,:), resolution_map(r,:), lat_map(r,:), lng_map(r,:)] = getElevationsPath(lat(r), Coord1(2), lat(r), Coord2(2), SAMPLES, 'key', API_KEY);
        end

        save(['backup_' num2str(SAMPLES)], 'elevation_map', 'resolution_map', 'lat_map', 'lng_map');
    end

    disp('Displaying Data');

    % Displays the data
    figure('Name','Elevation');

    subplot(2,1,1);
    meshc(lng_map(1,:), lat_map(:,1), elevation_map);
    title('Elevation profile from Serra de Aire e Candeeiros');
    xlabel('Latitude (º)');
    ylabel('Longitude (º)');
    zlabel('Elevation (m)');
    colorbar;

    subplot(2,1,2);
    meshc(lng_map(1,:), lat_map(:,1), resolution_map);
    title('Resolution of the Elevation Data of Serra de Aire e Candeeiros');
    xlabel('Latitude (º)');
    ylabel('Longitude (º)');
    zlabel('Resolution (m)');

------------------------------------------------------------------------

  MAIN ADVANTAGES (compares to getElevations from Jarek Tuszynski):
      - Only consumes one API request for n resolution points between the
      path, instead of x API request from the n points from the request
      of the original script;
      - Easier to use in some cases, mainly when you need to get a
      elevation profile of a big area (elevation profile line by line)

  THIS SCRIPT IS A MODIFIED VERSION OF GetElevation Script from:
  Author: Jarek Tuszynski (jaroslaw.w.tuszynski@leidos.com)
  Documentation: https://developers.google.com/maps/documentation/elevation/
  
  MODIFIED VERSION AUTHOR: José Rosa
  Github: https://github.com/pinxau1000/Matlab-Google-Elevation-API
  Tested on Matlab R2017a

  A resolution value, indicating the maximum distance between data points
    from which the elevation was interpolated, in meters. This property will
    be missing if the resolution is not known. Note that elevation data becomes
    more coarse (larger resolution values) when multiple points are passed.
    To obtain the most accurate elevation value for a point, it should be queried
    independently.


```

![image2](https://raw.githubusercontent.com/pinxau1000/Matlab-Google-Elevation-API/master/Example_Script_2.png)
