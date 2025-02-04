/ip firewall layer7-protocol add comment="P2P WWW web base content Matching / umar" name=p2p_www regexp=\ "^.*(get|GET).+(torrent|thepiratebay|isohunt|entertane|demonoid|btjunkie|mininova|flixflux|vertor|h33t|zoozle|bitnova|bitsoup|meganova|fulldls|btbot|fenopy|gpirate|commonbits).*\$"

/ip firewall layer7-protocol add comment="P2P DNS Matching / umar" name=p2p_dns regexp=\ "^.+(torrent|thepiratebay|isohunt|entertane|demonoid|btjunkie|mininova|flixflux|vertor|h33t|zoozle|bitnova|bitsoup|meganova|fulldls|btbot|fenopy|gpirate|commonbits).*\$"

/ip firewall mangle add action=mark-packet chain=postrouting comment="p2p download" disabled=no layer7-protocol=p2p_www new-packet-mark="p2p download" passthrough=no

/ip firewall mangle add action=mark-packet chain=postrouting disabled=no layer7-protocol=p2p_dns new-packet-mark="p2p download" passthrough=no 

/ip firewall filter add action=drop chain=forward comment="Block P2p_www Packets / umar" disabled=no layer7-protocol=p2p_www

/ip firewall filter add action=drop chain=forward comment="Block P2p_dns Packets / umar" disabled=no layer7-protocol=p2p_dns

/ip firewall filter add action=drop chain=forward comment="TORRENT No 2: block outgoing DHT" content=d1:ad2:id20: disabled=no dst-port=1025-65535 packet-size=95-190 protocol=udp

/ip firewall filter add action=drop chain=forward comment="TORRENT No 3: block outgoing TCP announce" content="info_hash=" disabled=no dst-port=2710,80 protocol=tcp

/ip firewall filter add action=drop chain=forward comment="TORRENT No 4: prohibits download .torrent files. " content="\r\nContent-Type: application/x-bittorrent" disabled=no protocol=tcp src-port=80

/ip firewall filter add action=drop chain=forward comment="TORRENT No 5: 6771 block Local Broadcast" content="\r\nInfohash:" disabled=no dst-port=6771 protocol=udp