require 'bundler'
Bundler.setup

require 'cucumber'
require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support

require 'sniff'
Sniff.init File.join(File.dirname(__FILE__), '..', '..'), :earth => [:industry, :locality, :fuel], :cucumber => true, :logger => 'log/test_log.txt'

require 'loose_tight_dictionary'
