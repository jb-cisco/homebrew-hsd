brew tap jb-cisco/hsd
brew install jb-cisco/hsd/hsd

Usable commands

hsd get reservation
hsd create reservation
hsd delete reservation <reservationid>

You must configure a configuration file in ~/.hsd with the contents as shown below:
hsdkey: <key you are provided for use of the hsd tool, this is NOT a SCC key>
