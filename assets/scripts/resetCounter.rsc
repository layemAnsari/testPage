:local uptime [/ip hotspot user get $user uptime]
:local limituptime [/ip hotspot user get $user limit-uptime]
:log info ("uptime: $uptime     limit: $limituptime")
:local remaining ($limituptime - $uptime)
:if ($remaining > 00:05:00) do={
	/ip hotspot user reset-counter $user}
}