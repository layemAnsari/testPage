:log info ("Start Restoring Uptime")
:delay 00:00:01

foreach src in [ /sys script find where comment="saveduptime" ] do={
  :local uname [/sys script get $src name]
  :log info (uname)
  :local uptime [/sys script get $src source]
  :log info (uptime)

  :local user [/ip hotspot user find name=$uname]
  :if ($user="") do={
	/sys script remove $src;
  } else={
	:local prevuptime [/ip hotspot user get $user limit-uptime]
	:log info ($prevuptime)
	:local newuptime ($prevuptime-$uptime)
	:log info ($newuptime)
	/ip hotspot user set $user limit-uptime=$newuptime;
	/sys script remove $src;
  }
  :delay 00:00:01;
};

:log info ("Done Restore")