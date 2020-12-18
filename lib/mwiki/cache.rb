# frozen_string_literal: true

module Mwiki
  # Mwiki::Cache
  class Cache
    DIR = "#{ENV.fetch('HOME')}/.mwiki"

    class << self
      # @return [void]
      def create_directory
        Dir.mkdir(DIR) unless Dir.exist?(DIR)
      end
    end

    # @param [String] word
    # @return [void]
    def initialize(word)
      @word = word
    end

    # @return [String, NilClass]
    def content
      File.read(file) if exist?
    end

    # @param [String] content
    # @return [String]
    def write(content)
      File.write(file, content)
      content
    end

    private

    # @return [TrueClass, FalseClass]
    def exist?
      File.exist?(file)
    end

    # @return [String]
    def file
      "#{DIR}/#{@word}.txt"
    end
  end
end
