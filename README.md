browser start stop mac
=================

Copy "com.user.startstop.plist" under /Library/LaunchAgents/

This runs start.sh on startup which in turn starts service.rb

The server will start single threaded on the local machine on port 4567

The user has been given sudo permissions to run networksetup without asking for a password.
This allows it to change the proxy settings for the system.


To send commands to the Server -

Use curl to connect to connect to the server.

Example - curl "localhost:4567/start&name=chrome&version=35&url=yahoo.com"

