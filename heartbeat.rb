#!/usr/bin/env ruby
require 'net/ping'

# file must be supplied
file = ARGV[0]

# line 1 - ip address to check
ip = IO.readlines(file)[0].strip

# line 2 - prior status (1/0 of on/off)
status = IO.readlines(file)[1].strip

# line 3 - pushover apptoken
apptoken = IO.readlines(file)[2].strip

# line 4 - pushover usertoken
usertoken = IO.readlines(file)[3].strip

# nickname of computer to check
name = "Compy"

# check ping
# true if online, false if offline
def up?(host)
    check = Net::Ping::External.new(host)
    check.ping?
end

# notify
def notify(message, apptoken, usertoken)
    puts "Notifying of status change.."
    message = message + "\n" + DateTime.parse(Time.now.to_s).strftime("%d/%m/%Y %H:%M")

    puts message
    pushover(message, apptoken, usertoken)
end

# notify via pushover
def pushover(message, apptoken, usertoken)
  puts 'Responding via pushover.'
  puts
  url = URI.parse("https://api.pushover.net/1/messages.json")
  req = Net::HTTP::Post.new(url.path)
  req.set_form_data({
                        :token => apptoken,
                        :user => usertoken,
                        :message => message,
                    })
  res = Net::HTTP.new(url.host, url.port)
  res.use_ssl = true
  res.verify_mode = OpenSSL::SSL::VERIFY_PEER
  res.start {|http| http.request(req) }
end

# save status of machine
def save(filename,ip,status, apptoken, usertoken)
    puts "Saving..."

    File.open(filename, 'w') do |file|
      file.write ip
      file.write "\n"
      file.write status
      file.write "\n"
      file.write apptoken
      file.write "\n"
      file.write usertoken
      file.write "\n"
    end
end

# output run..
puts "Checking " + name + " heartbeat..."

# online
if up?(ip)
    puts "Online"

    # notify and save if status changed
    if(status == "0")
        notify(name+ " is online.", apptoken, usertoken)
        status = 1
        save(file, ip, status, apptoken, usertoken)
    else 
        puts "No change"
    end
# offline
else
    puts "Offline"
    
    # notify and save if status changed
    if(status == "1")
        notify(name+ " when offline. :(", apptoken, usertoken)
        status = 0
        save(file, ip, status, apptoken, usertoken)
    else 
        puts "No change"
    end
end