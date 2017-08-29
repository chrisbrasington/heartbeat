# heartbeat

Monitor online status of another machine via ping. Notify when status changes via pushover.

### Sample config.txt
```
192.168.XXX.XXX
0
APPTOKEN
USERTOKEN
```

### Sample crontab entry 
```
*/1 * * * * /home/pi/repo/heartbeat/heartbeat.rb /home/pi/repo/heartbeat/config.txt 2>&1
```

