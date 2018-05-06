# Matlab-Google-Elevation-API
Matlab Script to get a elevation profile along a path defined between two points with n resolution samples.

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

  lat = linspace(39.549937, 39.505018, 10);   % Latitude Points
  dist = linspace(-2500, 2500, 10);   % Distance between points (m)

  %Creates a matrix to store all the elevations
  elevation_map = nan*dist;

  for r=1:length(lat)
      [elevation_map(r,:), resolution_map(r,:), lat_map(r,:), lng_map(r,:)] = getElevationsPath(lat(r), -8.819350, lat(r), -8.761150, 10, 'key', 'YOUR-API-KEY');
  end

  figure('Name','Elevation');
  meshc(dist,dist,elevation_map)
  title('Elevation profile from Serra de Aire e Candeeiros');
  xlabel('distance in meters');
  ylabel('elevation in meters');
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
