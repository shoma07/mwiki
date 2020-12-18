# frozen_string_literal: true

require 'optparse'
require 'net/http'
require 'json'
require 'mwiki/version'
require 'mwiki/cache'
require 'mwiki/client'
require 'mwiki/cli'

module Mwiki
  class Error < StandardError; end
  # Your code goes here...
end
