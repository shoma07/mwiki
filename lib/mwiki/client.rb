# frozen_string_literal: true

module Mwiki
  # Mwiki::Client
  class Client
    # @param [String] host
    # @param [String] word
    # @return [void]
    def initialize(host, word)
      @host = host
      @word = word
    end

    # @return [String]
    # @raise [Error]
    def content
      pages = fetch_pages
      raise Error, 'No search results' unless pages.is_a?(Hash)

      pages.values.filter_map do |page|
        next unless page['extract']

        "= #{page['title']} =\n#{page['extract']}"
      end.join("\n")
    end

    private

    # @return [Hash, NilClass]
    def fetch_pages
      JSON.parse(Net::HTTP.get_response(uri).body).dig('query', 'pages')
    end

    # @return [URI]
    def uri
      URI.parse("https://#{@host}/w/api.php?#{URI.encode_www_form(params)}")
    end

    # @return [Hash]
    def params
      {
        format: 'json',
        action: 'query',
        prop: 'extracts',
        explaintext: nil,
        exsectionformat: 'wiki',
        redirects: nil,
        titles: @word
      }
    end
  end
end
