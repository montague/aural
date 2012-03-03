require 'cgi'
require 'mechanize'
require 'benchmark'

module Aural
  class Downloader
    def grab(url)
      @filename = "#{url.slice(url.index('v=') + 2, 6)}.flv"
      agent = Mechanize.new
      page = agent.get url
      regex = /,url=(http%3A%2F%2F.*?\.youtube.com%2Fvideoplayback%3Fsparams.*?id%3D.*?)\\u0026/

      page.content.scan(regex) do |m|
        m = m.first
        next unless m =~ /algorithm/
        next if @written
        File.open(@filename, 'w') do |f|
          p 'ok, first i gotta find your video. looking for it now...'

          time = Benchmark.measure do
            response = agent.get(CGI.unescape(m))
            if response.is_a?(Mechanize::File) && response.header["content-type"] == "video/x-flv"
              p 'cool, found it. saving it now.'
              f.write response.content
              @written = true
              p "saved #{@filename}"
            end
          end
          if @written
            p time
          end
        end
      end
      @filename
    end

    private
    def format_title(str)
      str.strip.split("\n").first
    end


  end
end




if __FILE__ == $0
  #file = File.expand_path("../../../#{filename}", __FILE__)
  #
  #`ffmpeg -i #{file} -acodec libmp3lame -ac 2 -ab 128K _t2TzJ.mp3`
  #d = Aural::Downloader.new
  #filename = d.grab("http://www.youtube.com/watch?v=_t2TzJOyops")
  #puts "==================>#{filename}"
end
