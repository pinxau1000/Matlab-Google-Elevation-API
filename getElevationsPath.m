function [elevations, resolution, latitudes, longitudes] = getElevationsPath(latitude1, longitude1, latitude2, longitude2, resolution, varargin)
% GETELEVATIONSPATH queries Google Maps API webservice for ground elevations
% along the path between the latitudes and longitues provided with n
% resolution samples.
% 
%   elevation = getElevationsPath(latitude1, longitude1, latitude2,
%   longitude2, resolution, 'key', 'YOUR-API-KEY');
%   Returns <resolution> points of elevation from the path from 
%   Point1(latitude1, longitude1) to Point2 (latitude2, longitude2).
% 
%   [elevation, resolution] = getElevationsPath(latitude1, longitude1, 
%   latitude2, longitude2, resolution, 'key', 'YOUR-API-KEY');
%   Returns <resolution> points of elevation and resolution from the path
%   from Point1(latitude1, longitude1) to Point2 (latitude2, longitude2).
% 
%   [elevation, resolution, latitudes, longitudes] = 
%   getElevationsPath(latitude1, longitude1, latitude2, longitude2, 
%   resolution, 'key', 'YOUR-API-KEY');
%   Returns <resolution> points of elevation, resolution, latitudes and
%   longitudes from the path from Point1(latitude1, longitude1) to Point2
%   (latitude2, longitude2).
% 
% ------------------------------------------------------------------------
%   Example:
%                   Get an area profile. Area vertex are:
%                       VERTEX            LAT        LONG
%                   Up Left Corner:    39.549937, -8.819350
%                   Up Right Corner:   39.549937, -8.761150
%                   Down Left Corner:  39.505018, -8.819350
%                   Down Right Corner: 39.505018, -8.761150
% 
%     clearvars;
%     clc;
% 
%     SAMPLES = 100;
%     API_KEY = 'YOUR-API-KEY';   % Read https://developers.google.com/maps/documentation/elevation/get-api-key
% 
%     Coord1 = [39.549937, -8.819350];
%     Coord2 = [39.505018, -8.761150];
% 
%     try
%         load(['backup_' num2str(SAMPLES)]);
% 
%         % Sucess loaded but the number of samples are different or the
%         % coordinates are different. Need to request elevations again.
%         if length(lat_map)~=SAMPLES || lat_map(1)~=Coord1(1) || lng_map(1)~=Coord1(2) ...
%                 || lat_map(length(lat_map),1)~=Coord2(1) || lng_map(1,length(lng_map))~=Coord2(2)
% 
%             disp('Requesting Elevations to Google');
% 
%             lat = linspace(Coord1(1), Coord2(1), SAMPLES);  %Latitude Points
% 
%             % Preallocating memory for speed improvement
%             elevation_map = NaN(SAMPLES, SAMPLES);
%             resolution_map = NaN(SAMPLES, SAMPLES);
%             lat_map = NaN(SAMPLES, SAMPLES);
%             lng_map = NaN(SAMPLES, SAMPLES);
% 
%             % Gets the area elevations.
%             for r=1:length(lat)
%                 [elevation_map(r,:), resolution_map(r,:), lat_map(r,:), lng_map(r,:)] = getElevationsPath(lat(r), Coord1(2), lat(r), Coord2(2), SAMPLES, 'key', API_KEY);
%             end
% 
%             save(['backup_' num2str(SAMPLES)], 'elevation_map', 'resolution_map', 'lat_map', 'lng_map');
%         end
%     catch
% 
%         disp('Requesting Elevations to Google');
% 
%         lat = linspace(Coord1(1), Coord2(1), SAMPLES);  %Latitude Points
% 
%         % Preallocating memory for speed improvement
%         elevation_map = NaN(SAMPLES, SAMPLES);
%         resolution_map = NaN(SAMPLES, SAMPLES);
%         lat_map = NaN(SAMPLES, SAMPLES);
%         lng_map = NaN(SAMPLES, SAMPLES);
% 
%         % Gets the area elevations.
%         for r=1:length(lat)
%             [elevation_map(r,:), resolution_map(r,:), lat_map(r,:), lng_map(r,:)] = getElevationsPath(lat(r), Coord1(2), lat(r), Coord2(2), SAMPLES, 'key', API_KEY);
%         end
% 
%         save(['backup_' num2str(SAMPLES)], 'elevation_map', 'resolution_map', 'lat_map', 'lng_map');
%     end
% 
%     disp('Displaying Data');
% 
%     % Displays the data
%     figure('Name','Elevation');
% 
%     subplot(2,1,1);
%     meshc(lng_map(1,:), lat_map(:,1), elevation_map);
%     title('Elevation profile from Serra de Aire e Candeeiros');
%     xlabel('Latitude (º)');
%     ylabel('Longitude (º)');
%     zlabel('Elevation (m)');
%     colorbar;
% 
%     subplot(2,1,2);
%     meshc(lng_map(1,:), lat_map(:,1), resolution_map);
%     title('Resolution of the Elevation Data of Serra de Aire e Candeeiros');
%     xlabel('Latitude (º)');
%     ylabel('Longitude (º)');
%     zlabel('Resolution (m)');
%
% ------------------------------------------------------------------------
% 
%   MAIN ADVANTAGES (compares to getElevations from Jarek Tuszynski):
%       - Only consumes one API request for n resolution points between the
%       path, instead of x API request from the n points from the request
%       of the original script;
%       - Easier to use in some cases, mainly when you need to get a
%       elevation profile of a big area (elevation profile line by line)
% 
%   THIS SCRIPT IS A MODIFIED VERSION OF GetElevation Script from:
%   Author: Jarek Tuszynski (jaroslaw.w.tuszynski@leidos.com)
%   Documentation: https://developers.google.com/maps/documentation/elevation/
%   
%   MODIFIED VERSION AUTHOR: José Rosa
%   Github: https://github.com/pinxau1000/Matlab-Google-Elevation-API
%   Tested on Matlab R2017a
%
%   A resolution value, indicating the maximum distance between data points
%     from which the elevation was interpolated, in meters. This property will
%     be missing if the resolution is not known. Note that elevation data becomes
%     more coarse (larger resolution values) when multiple points are passed.
%     To obtain the most accurate elevation value for a point, it should be queried
%     independently.
    
%% process varargin
keyStr = '';
if nargin>2
  p = inputParser;
  p.addParameter('key', '', @ischar)
  p.FunctionName = 'getElevations';
  p.parse(varargin{:})
  results = p.Results;
  if ~isempty(results.key)
    keyStr = sprintf('&key=%s', results.key);
  end
end

%% Check inputs
nPos = numel(latitude1);
assert(nPos>0, 'Latitude1 can not be empty')
assert(nPos<2, 'Latitude1 must be one element')
nPos = numel(longitude1);
assert(nPos>0, 'Longitude1 can not be empty')
assert(nPos<2, 'Longitude1 must be one element')
nPos = numel(latitude2);
assert(nPos>0, 'Latitude2 can not be empty')
assert(nPos<2, 'Latitude2 must be one element')
nPos = numel(longitude2);
assert(nPos>0, 'Longitude2 can not be empty')
assert(nPos<2, 'Longitude2 must be one element')
nPos = numel(resolution);
assert(nPos>0, 'Resolution can not be empty')
assert(nPos<2, 'Resolution must be one element')
assert(resolution>1, 'Resolution must be at least 2')
assert(resolution<513, 'Resolution is limited to 512')

assert(latitude1 >= -90 && latitude1 <= 90 && latitude2 >= -90 && latitude2 <= 90, 'Latitudes has to be between -90 and 90')
assert(longitude1 >=-180 && longitude1 <=180 && longitude2 >=-180 && longitude2 <=180, 'Longitudes has to be between -180 and 180')

%% Query Google
path = sprintf('%9.6f,%9.6f|%9.6f,%9.6f&samples=%d',latitude1,longitude1,latitude2,longitude2,resolution);

%% create query string and run a query
website = 'https://maps.googleapis.com/maps/api/elevation/xml?path=';
url = [website, path(1:end), keyStr];
str = urlread(url);

%% Parse results
elevations  = NaN(length(resolution));
resolution = NaN(length(resolution));
latitudes = NaN(length(resolution));
longitudes = NaN(length(resolution));

status = regexp(str, '<status>([^<]*)<\/status>', 'tokens');
switch status{1}{1}
case 'OK'
  res = regexp(str, '<elevation>([^<]*)<\/elevation>', 'tokens');
  elevations = cellfun(@str2double,res);
  
  if nargout>1
   res = regexp(str, '<resolution>([^<]*)<\/resolution>', 'tokens');
   resolution = cellfun(@str2double,res);
  end
  
  if nargout>2
   res = regexp(str, '<lat>([^<]*)<\/lat>', 'tokens');
   latitudes = cellfun(@str2double,res);
  end
  
  if nargout>3
   res = regexp(str, '<lng>([^<]*)<\/lng>', 'tokens');
   longitudes = cellfun(@str2double,res);
  end
 
case 'INVALID_REQUEST'
  error('Google Maps API request was malformed or Invalid Resolution');
case 'OVER_QUERY_LIMIT'
  error('Google Maps API requestor has exceeded quota');
case 'REQUEST_DENIED'
  error('Google Maps API did not complete the request (invalid sensor parameter?)');
case 'UNKNOWN_ERROR'
  error('Google Maps API: an unknown error.');
end
