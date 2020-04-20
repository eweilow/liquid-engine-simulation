function g = gravityAtAltitude(h)
    lat = 60 .* ones(1, length(h));
    lon = 18 .* ones(1, length(h));
    
    g = gravitywgs84(h, lat, lon, 'Exact');
end