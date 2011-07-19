function sec = hms2sec(hour, minute, second)
%HMS2SEC  Convert from hours, minutes and seconds to seconds.
   sec = second + 60 * minute + 3600 * hour;
