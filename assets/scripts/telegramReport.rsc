:log info "Sending report"
:local tgMyBotToken "7393527958:AAHNfUy5YKjoYCRettaK60DsO1aSfKXq0-k"
:local tgGroupChatID "-1002494624398"

:local usertime [/ip hotspot user get value-name=limit-uptime $user]
:local email [/ip hotspot user get value-name=email $user]
:local currentusername [/ip hotspot user get value-name=name $user]
:local uptime [/ip hotspot user get value-name=uptime $user]
:local userprofile [/ip hotspot user get value-name=profile $user]
:local macaddr [/ip hotspot active get value-name=mac-address [find user=$currentusername]]
:local hostname [/ip dhcp-server lease get value-name=host-name [find mac-address=$macaddr]]

:local overAllTotal [/file get "hotspot/overAllTotal" contents]
:set $overAllTotal [:tonum $overAllTotal]

:if ([:len $email] = 0) do={
	:local numProfile [:tonum $userprofile]
	:log info $numProfile
	:log info $overAllTotal
	:set $overAllTotal ($overAllTotal + $numProfile)
	:log info $overAllTotal
	/ip hotspot user set $user email="klmbyn.limescape@gmail.com"
	/file set "hotspot/overAllTotal.txt" contents=$overAllTotal
}
:local totalActiveUsers [:len [/ip hotspot active find]]

:local report ($report ."%0A%20Total:%20<strong>" . $overAllTotal . "</strong>")
:set $report ($report ."%0A%20Active:%20<strong>" . $totalActiveUsers . "</strong>")

:local msg ("(" . $userprofile . ") <strong>" . $currentusername . "</strong>%0A========================%0A<u>" . $macaddr . "</u>%0A-%20" . $hostname . "%20-%0A%0A<strong><u>" . $uptime . "</u></strong>%0Auptime%0A%0A<strong><u>" . $usertime . "</u></strong>%0Alimit-uptime%0A" . $report)
:local url ("https://api.telegram.org/bot" . $tgMyBotToken . "/sendMessage?chat_id=" . $tgGroupChatID . "&text=" . $msg . "&parse_mode=html")
:log info "connecting to telegram bot..."
/tool fetch keep-result=no url="$url"
:log info "done sending report."