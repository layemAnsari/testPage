:log info "Sending report"
:local tgMyBotToken "8150737943:AAEKugN2iRA2yXzgFZPymLDwjrJjDbMBz8Q"
:local tgGroupChatID "-1002362995199"


:local usertime [/ip hotspot user get value-name=limit-uptime $user]
:log info (usertime)
:local currentusername [/ip hotspot user get value-name=name $user]
:log info (currentusername)
:local uptime [/ip hotspot user get value-name=uptime $user]
:log info (uptime)
:local userprofile [/ip hotspot user get value-name=profile $user]
:log info (userprofile)
:local macaddr [/ip hotspot active get value-name=mac-address [find user=$currentusername]]
:log info (macaddr)
:local hostname [/ip dhcp-server lease get value-name=host-name [find mac-address=$macaddr]]
:log info (hostname)

:local p10
:local p20
:local p50

:local totalMsg ""
:foreach p in [/ip hotspot user profile find] do={
	:local pName $p
	:local exists [/file find name=$p]
	:if ([:len $exists] = 0) do={
		:if ($p = $userprofile) do={
			/file print file=$userprofile
			/file set [/file find name=$p] contents=1
			:local content [/file get $p contents]
			:local numcontent [:tonum $content]
			:local prod (numcontent * [:tonum $p])
			:set $totalMsg ($totalMsg."%0A".$p."php%20x%20".$content." = ".$prod%20)
		}
	}
	:if ([:len $exists] > 0) do={
		:local content [/file get $p contents]
		:local numcontent [:tonum $content]
		:local contentplusone $numcontent
		:if ($p = $userprofile) do={
			:set $contentplusone ($numcontent + 1)
		}
		/file set [/file find name=$p] contents=$contentplusone
		:set $totalMsg ($totalMsg."%0A".$p."php%20x%20".$content." = ".$prod%20)
	}

}

:local msg ("<strong>$currentusername</strong>%20%20%20%20%20%20%20%20%20%20%20%20%20%20(%20$userprofile%20)%0A========================%0A<u>$macaddr</u>%0A-%20$hostname%20-%0A%0A<strong><u>$uptime</u></strong>%0Auptime%0A%0A<strong><u>$usertime</u></strong>%0Alimit-uptime%0A".$totalMsg)
:log info (msg)
:local url ("https://api.telegram.org/bot$tgMyBotToken/sendMessage\?chat_id=$tgGroupChatID&text=$msg&parse_mode=html")
:log info (url)
/tool fetch keep-result=no url="$url"
