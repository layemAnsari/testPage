/sys scheduler add name="BackupUptime" start-time=startup interval=00:05:00 policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon on-event=":import /hotspot/assets/scripts/saveuptime.rsc"

:import /hotspot/assets/scripts/importOnce/blockStow.rsc
:log info ("Anti-Stow Added")

:import /hotspot/assets/scripts/importOnce/blockTorrent.rsc
:log info ("Anti-Torrent Added")

:import /hotspot/assets/scripts/importOnce/blockTether.rsc
:log info ("Anti-Tether Added")


:foreach profile in [/ip hotspot user profile find] do={
	:local onlogin [/ip hotspot user profile get $profile on-login]

        :log info ($onlogin)
	:local newonlogin ($onlogin ."

:import /hotspot/assets/scripts/telegramReport.rsc")
        :log info ($newonlogin)
	/ip hotspot user profile set $profile on-login=$newonlogin

	:local onlogout [/ip hotspot user profile get $profile on-logout]
        :log info ($onlogout)
	:local newonlogout ($onlogout ."

:import hotspot/assets/scripts/resetCounter.rsc")
        :log info ($newonlogout)

	/ip hotspot user profile set $profile on-login=$newonlogin on-logout=$newonlogout
}

