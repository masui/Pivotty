#! /usr/bin/ruby
# -*- coding: utf-8 -*-
require 'cgi'
require 'URI'

cgi = CGI.new('html3')
text = cgi.params['text'][0].to_s
level = cgi.params['level'][0].to_i

text = URI.unescape(text)

File.open("/tmp/text#{$$}","w"){ |f|
  f.puts text
}

system "killall say"
system "killall afplay"

sound = false
if level == 0 then
  sound = "/System/Library/Sounds/Glass.aiff"
  #sound = "oodaiko.mp3"
elsif level == 1 then
  sound = "/System/Library/Sounds/Hero.aiff"
  #sound = "kodaiko.mp3"
elsif level == 2 then
  sound = "/System/Library/Sounds/Blow.aiff"
elsif level == 3 then
  sound = "/System/Library/Sounds/Sosumi.aiff"
end

talker = "Samantha"
if text =~ /^Il /
  talker = 'Alice'
end
if text =~ /^El /
  talker = 'Monica'
end
if text =~ /^Die /
  talker = 'Anna'
end
if text =~ /^Die Hard/
  talker = 'Samantha'
end

if sound then
  system "/usr/bin/afplay #{sound} & /usr/bin/say -v #{talker} -r 250 \"#{text}\""
else
  system "/usr/bin/say -v #{talker} -r 250 \"#{text}\""
end

cgi.out {
  text
}

File.unlink "/tmp/text#{$$}"
