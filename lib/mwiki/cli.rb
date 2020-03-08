# frozen_string_literal: true

require 'optparse'
require 'net/http'
require 'json'

module Mwiki
  # Mwiki::CLI
  class CLI
    # @param argv [Array]
    # @return [Mwiki::CLI]
    def initialize(argv = [])
      create_cache_dir
      @host = 'ja.wikipedia.org'
      @cache = true
      parse!(argv)
      @word = argv.shift
      error('Please specify a word') if @word.to_s.length.zero?

      @content = nil
    end

    def parse!(argv = [])
      parser.parse!(argv)
    end

    def parser
      opt = OptionParser.new
      opt.on('--host=VAL', String, "mediawiki host, default: #{@host}") do |v|
        @host = v
      end
      opt.on('--[no-]cache', TrueClass, "use cache, default: #{@cache}") do |v|
        @cache = v
      end
      opt
    end

    def response
      res = Net::HTTP.get_response(uri)
      error('request error!') if res&.code.to_i != 200

      res
    end

    # @return [String]
    def content
      return cache_content if @cache && cache_exist?

      pages = JSON.parse(response.body).dig('query', 'pages')
      error('No search results') unless pages.is_a? Hash

      extracts = []
      pages.each do |_page_id, page|
        next unless page['extract']

        page['extract'].insert(0, "= #{page['title']} =\n")
        extracts << page['extract']
      end
      content = extracts.join("\n")
      write_cache(content)

      content
    end

    # @return [URI]
    def uri
      URI.parse("https://#{@host}/w/api.php?#{query}")
    end

    # @return [String]
    def query
      URI.encode_www_form({
                            format: 'json',
                            action: 'query',
                            prop: 'extracts',
                            explaintext: nil,
                            exsectionformat: 'wiki',
                            redirects: nil,
                            titles: @word
                          })
    end

    # @return [String]
    def cache_dir
      "#{ENV['HOME']}/.mwiki"
    end

    # @return [String]
    def cache_file
      "#{cache_dir}/#{@word}.txt"
    end

    def create_cache_dir
      Dir.mkdir(cache_dir) unless Dir.exist?(cache_dir)
    end

    # @return [TrueClass, FalseClass]
    def cache_exist?
      File.exist?(cache_file)
    end

    # @return [String]
    def cache_content
      File.read(cache_file)
    end

    def write_cache(content)
      File.write(cache_file, content)
    end

    def execute
      puts content
    end

    def error(str)
      puts str
      exit 1
    end
  end
end
