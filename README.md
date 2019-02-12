# start-TSlog
Sometimes, users experience problems which dissapear before you can act. With this script, wireshark/Tshark runs continuously in the background, add it to the user logonscrip GPO or in the startup folder or whatever means you want.

The user just has to run the script a 2nd time (just double click will do)  when the networking problem arises and it will take a copy of the continuous, rotational logs. Allowing you to observe past and present connectivity. Adjust the variables to your own needs.

I guess it would make more sense creating 2 files, but now it's an all-in-one script.

## Prerequisites
Powershell v5.0 for the archiving functionality and obviously wireshark (or well Tshark) installed on the user's computer.
Haven't tested this in a domain environment yet.
