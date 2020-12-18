# frozen_string_literal: true

module Mwiki
  # Mwiki::CLI
  class CLI
    # @param argv [Array]
    # @return [Mwiki::CLI]
    def initialize(argv = [])
      Cache.create_directory
      @option = { host: 'ja.wikipedia.org', cache: true }
      parser.parse!(argv)
      @word = argv.shift
      raise Error, 'Please specify a word' if @word == ''
    end

    # @return [void]
    def execute
      puts content
    end

    private

    # @return [String]
    def content
      cache = Cache.new(@word)
      (@option[:cache] && cache.content) ||
        cache.write(Client.new(@option[:host], @word).content)
    end

    # @return [OptionParser]
    def parser
      opt = OptionParser.new
      opt.on('--host=VAL', String, "mediawiki host, default: #{@option[:host]}") do |v|
        @option[:host] = v
      end
      opt.on('--[no-]cache', TrueClass, "use cache, default: #{@option[:cache]}") do |v|
        option[:cache] = v
      end
      opt
    end
  end
end
