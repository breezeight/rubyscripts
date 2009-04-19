#!/usr/bin/ruby
load '/home/nicola/backup.conf'


def pid_exists? (pid)
    system "kill -0 #{pid}"
    return $? == 0
end


#Check if previoud process are still running
is_previous_process_running = false
puts File.new(BACKUPPIDFILE, "r+").read 
previous_pid = Integer( File.new(BACKUPPIDFILE, "r+").read )
begin
    Process.kill(0, previous_pid)
    puts "#{previous_pid} is running"
    is_previous_process_running = true
rescue Errno::EPERM                     # changed uid
    puts "No permission to query #{previous_pid}!";
rescue Errno::ESRCH
    puts "#{previous_pid} is NOT running.";      # or zombied
rescue
    puts "Unable to determine status for #{previous_pid} : #{$!}"
end

exit 1 if is_previous_process_running

#Save current PID
pidfile = File.new(BACKUPPIDFILE, "w+")
pidfile.write(Process.pid)
pidfile.flush
sleep 100


#sync

puts "#{RSYNC} -a #{SOURCEDIRS} #{BACKUPDIR}"
ret = `#{RSYNC} -a #{SOURCEDIRS} #{BACKUPDIR}`
puts ret
# SOURCEDIRS