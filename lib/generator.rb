require 'net/http'
require 'uri'
require 'nokogiri'
require 'rss'

class GeneratorApp
  def call(env)
    req = Rack::Request.new(env)
    if req.path.rpartition('/')[-1] == 'podcast'
      prg = req['program']
      if prg.nil? then
        return [404, {}, ["Not Found"]]
      end
      url_base = 'http://www.mbs1179.com/' + prg + '/rss.xml'
      rss_str  = Net::HTTP.get(URI(url_base))
      rss = RSS::Parser.parse(rss_str,false)
      rss.channel.items.each do |item|
        item.pubDate = item.pubDate.rfc822
      end
      [200, {}, [rss.to_s]]
    else
      [404, {}, ["Not Found"]]
    end
  end
end

