:log info ("Cleaning hotspot users");

:local function convertToSeconds uptime do={
	:local sec 0;
	:foreach t in=[:toarray $uptime] do={
		:if ([:pick $t 0 1] = "d") do={
			:set sec ($sec + ([:pick $t 0 [:len $t - 1]] * 86400))
		}
		else={
			:if ([:pick $t 0 1] = "h") do={
				:set sec ($sec + ([:pick $t 0 [:len $t - 1]] * 3600))
			}
			else={
				:if ([:pick $t 0 1] = "m") do={
					:set sec ($sec + ([:pick $t 0 [:len $t - 1]] * 60))
				}
				else={
					:set sec ($sec + ([:pick $t 0 [:len $t - 1]]))
				}
			}
		}
	}
	:return $sec;
}

foreach user in [ /ip hotspot user ] do={
	:local uname [/ip hotspot user get $user user];
	:local uptime [/ip hotspot user get $user uptime];
	:local uptimeSec [/local function convertToSeconds $uptime]
	:local limit [/ip hotspot user get $user limit-uptime];
	:local limitSec [/local function convertToSeconds $limit]
	:local remaining $limitSec-$uptimeSec;
	:log info ("remaining: $remaining");
	:local src [/sys script find name=$uname];
	:if ($remaining <= 00:05:00) do={
		:local isActive 
		/ip hotspot user remove $user;
		:local src [/sys script find where name=$uname];
		/sys script remove $src;
		:delay 00:00:01;
	}
};

:log info ("Done cleaning hotspot users");