require 'optparse'
require 'net/http'
require 'json'
module Mwiki
  class CLI
    class << self
      def execute(argv = [])
        host = 'ja.wikipedia.org'
        output = nil
        opt = OptionParser.new
        opt.on('--host=VAL', String, "mediawiki host, default: #{host}") do |v|
          host = v
        end
        opt.on('--output=VAL', '-o=VAL', String, 'output path') do |v|
          output = v
        end
        opt.parse!(argv)
        word = argv.shift
        if word.to_s.length == 0
          puts 'Please specify a word'
          exit
        end
        query = URI.encode_www_form({
                  format: "json",
                  action: "query",
                  prop: "extracts",
                  explaintext: nil,
                  exsectionformat: "wiki",
                  redirects: nil,
                  titles: word,
                })
        uri = URI.parse("https://#{host}/w/api.php?#{query}")
        res = Net::HTTP.get_response(uri)
        if res&.code.to_i != 200
          puts 'request error!'
          exit
        end
        pages = JSON.parse(res.body).dig(*%w[query pages])
        unless pages.is_a? Hash
          puts 'No search results'
          exit
        end
        extracts = []
        pages.each do |page_id, page|
          next unless page["extract"]
          page["extract"].insert(0, "= #{page['title']} =\n")
          extracts << page['extract']
        end
        content = extracts.join("\n")
        if output.nil?
          puts content
        else
          File.write output, content
          puts 'write result'
        end
      end
    end
  end
end
