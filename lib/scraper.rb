require 'rubygems'
require 'anemone'
require 'csv'
require 'yaml'
require 'nokogiri'
require 'open-uri'
#require  'scraper/flipkart_scraper'
require "#{File.join(File.dirname(__FILE__),  'scraper/flipkart_crawler')}"
require "#{File.join(File.dirname(__FILE__),  'scraper/wiki_scraper')}"
 
module Scraper
  VERSION = "0.1"
  ::APP_CONFIG = YAML.load_file("config.yml")
end
