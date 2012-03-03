require 'cgi'
require 'mechanize'
require 'benchmark'

module Aural
  class LinkParser
    class << self
      def parse(link)
        @agent ||= Mechanize.new
      end
    end
  end
end


if __FILE__ == $0
  url = 'http://www.youtube.com/watch?v=M-SKbQWXzyk'
  agent = Mechanize.new

  page = agent.get url

  regex = /,url=(http%3A%2F%2F.*?\.youtube.com%2Fvideoplayback%3Fsparams.*?id%3D.*?)\\u0026/

  page.content.scan regex do |m|
    m = m.first
    next unless m =~ /algorithm/

    time = Benchmark.measure do
      File.open('video.flv', 'w') do |f|
        response = agent.get(CGI.unescape(m)).content
        if response.content_type == "video/x-flv"
          @written = true
          f.write response.content
          p "video saved."
        else
          p "not a video file. skipping"
        end
      end
    end
    p time if @written
  end

  #uri = URI('http://www.youtube.com/watch?v=M-SKbQWXzyk')
  #
  #http = Net::HTTP.new(uri.host)
  #puts uri.host
  #puts uri.path
  #puts uri.query
  #
  #path = '/watch?v=M-SKbQWXzyk'
  #
  #resp, data = http.get()
  #
  #cookies = resp.response['set-cookie']

  #puts resp.response.body
  #puts cookies
  #File.open(File.expand_path('../../../data/sample_html.html', __FILE__),'r') do |f|
  #  html = f.read
  #  regex = /,url=(http%3A%2F%2F.*?\.youtube.com%2Fvideoplayback%3Fsparams.*?id%3D.*?)\\u0026/
  #
  #
  #  html.scan(regex) do |m|
  #    m = m.first
  #    next unless m =~ /algorithm/
  #
  #    uri = URI(CGI.unescape(m))
  #
  #    resp, data = Net::HTTP.new(uri.host).get(uri.path, 'Cookie' => cookies )
  #
  #    puts resp.response.inspect
  #  end
  #
  #
  #end
end

#http://v5.nonxt5.c.youtube.com/videoplayback?sparams=algorithm%2Cburst%2Ccp%2Cfactor%2Cid%2Cip%2Cipbits%2Citag%2Csource%2Cexpire&fexp=903114%2C919001&algorithm=throttle-factor&itag=34&ip=66.0.0.0&burst=40&sver=3&signature=534A16BAA54CFD99075264EA6C4725FC25070A21.1D56618E16E469430565158E3A25412E06840A66&source=youtube&expire=1330771476&key=yt1&ipbits=8&factor=1.25&cp=U0hSRVdST19MUENOMl9PTFNFOmVSMmFjRExMN2x1&id=9867ad18f3e2878a&cm2=1&redirect_counter=1