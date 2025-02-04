:log info ("Starting Uptime Backup")

foreach user in [/ip hotspot active find] do={
  :local uname [/ip hotspot active get $user user]
  :log info (uname)
  :local uptime [/ip hotspot active get $user uptime]
  :local timeleft [/ip hotspot active get $user session-time-left]
  :log info ("uptime: $uptime      remaining: $timeleft")

  :local hotspotuser [/ip hotspot user find name=$uname]
  /ip hotspot user set $hotspotuser limit-uptime=$timeleft
  /ip hotspot user reset-counters $hotspotuser
  :delay 00:00:01;
};

:log info ("Done Backup")