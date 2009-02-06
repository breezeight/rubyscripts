#!/usr/bin/ruby
if ARGV.size != 1
        puts "USAGE: replace -i <input> -r <regexp> "
        exit
end

if !File::exist?(ARGV[0]) || File.new(ARGV[0]).stat.directory?
        puts "ERROR the argument must be a directory"
        exit
end

File.open(ARGV[0]) do |i|
  while( a = i.gets )
    puts a.sub(/.*/, '"\0\n"');
  end
end

