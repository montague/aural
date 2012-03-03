require 'cgi'
require 'mechanize'
require 'benchmark'
require 'tempfile'


def temp_file
  file = Tempfile.new('foo')
  begin
    yield file
  ensure
    file.close
    file.unlink
  end
end

def grab(url)
  agent = Mechanize.new
  page = agent.get url
  title = page.title.strip.split("\n").first
  filename = "#{title}.mp3"

  regex = /,url=(http%3A%2F%2F.*?\.youtube.com%2Fvideoplayback%3Fsparams.*?id%3D.*?)\\u0026/

  page.content.scan(regex) do |m|
    m = m.first
    next unless m =~ /algorithm/
    next if @written

    puts "looking for your video. this might take a minute or two."
    response = agent.get(CGI.unescape(m))
    if response.is_a?(Mechanize::File) && response.header["content-type"] == "video/x-flv"
      puts "ok found it. creating the mp3 now."
      temp_file do |file|
        file.write(response.content)
        transcode(file.path, filename)
      end
      exit
    end
  end
end



def transcode(path,filename)
  cmd = "ffmpeg -i \"#{path}\" -acodec libmp3lame -ac 2 -ab 128K \"#{filename}\""
  announce cmd
  if system cmd
    puts "done! enjoy your shiny new mp3: #{filename}"
  else
    puts "shit. something broke. ask ian to fix this."
  end
end

def announce(s)
  puts "*"*100
  puts s
  puts "*"*100
end


grab ARGV.shift
