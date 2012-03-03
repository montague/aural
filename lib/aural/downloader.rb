require 'cgi'
require 'mechanize'
require 'open-uri'
require 'benchmark'

module Aural
  class Downloader
    class << self
      def grab(url)
        agent = Mechanize.new
        id = url[-6..-1]
        page = agent.get url
        regex = /,url=(http%3A%2F%2F.*?\.youtube.com%2Fvideoplayback%3Fsparams.*?id%3D.*?)\\u0026/

        # reverse because i suspect smaller video files are listed last in the page.
        page.content.scan(regex) do |m|
          m = m.first
          next unless m =~ /algorithm/
          next if @written

          filename = "#{id}.flv"
          puts "HERE!!"
          File.open(filename, 'w') do |f|
            p 'ok, first i gotta find your video. looking for it now...'

            time = Benchmark.measure do
              response = agent.get(CGI.unescape(m))
              if response.is_a?(Mechanize::File) && response.header["content-type"] == "video/x-flv"
                p 'cool, found it. saving it now.'
                f.write response.content
                @written = true
                p "saved #{filename}"
              end
            end
            if @written
              p time
            end
          end
        end
      end
    end
  end
end


if __FILE__ == $0

  Aural::Downloader.grab("http://www.youtube.com/watch?v=LXuYGTAwTyE")
  #url = 'http://www.youtube.com/watch?v=M-SKbQWXzyk'
  #agent = Mechanize.new
  #
  #page = agent.get url
  #
  #regex = /,url=(http%3A%2F%2F.*?\.youtube.com%2Fvideoplayback%3Fsparams.*?id%3D.*?)\\u0026/
  #
  #page.content.scan regex do |m|
  #  m = m.first
  #  next unless m =~ /algorithm/
  #
  #  time = Benchmark.measure do
  #    File.open('video.flv', 'w') do |f|
  #      response = agent.get(CGI.unescape(m)).content
  #      if response.content_type == "video/x-flv"
  #        @written = true
  #        f.write response.content
  #        p "video saved."
  #      else
  #        p "not a video file. skipping"
  #      end
  #    end
  #  end
  #  p time if @written
  #end
end
# http://tc.v23.cache5.c.youtube.com/videoplayback?ip=66.0.0.0&ipbits=8&source=youtube&cm2=1&burst=40&sparams=algorithm%2Cburst%2Ccp%2Cfactor%2Cid%2Cip%2Cipbits%2Citag%2Csource%2Cexpire&sver=3&expire=1330774066&fexp=903114%2C919001&id=da6cec1c18b630de&signature=786BECA5C30A5D342BDA1CA0566527A3DBBF12EE.6605968443FB99263377F0DFDAD58496B7F53E74&algorithm=throttle-factor&factor=1.25&cp=U0hSRVdSUl9LUENOMl9PTFZBOmVSMmFjRExPM2t1&keepalive=yes&itag=34&key=yt1&range=13-1781759&redirect_counter=2