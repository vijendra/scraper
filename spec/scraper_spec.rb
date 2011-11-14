require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rake'

describe "Scraper" do
  let(:base_path) {File.expand_path(File.join(File.dirname(__FILE__), '..')) } #FIXME find some better way
  
  it "should load 'config.yml'" do
    ::APP_CONFIG.keys.include?('flipkart_url').should be_true
  end
    
  describe "crawling flipkart" do
    it "should look for url 'www.flipkart.com'" do
      ::APP_CONFIG['flipkart_url'].should =~ /flipkart.com/
    end
    
    it "should parse and store the content of a book with ISBN 9709726315, in csv" do
      main_page = File.read("#{base_path}/spec/fixtures/books.html")
      books_list = File.read("#{base_path}/spec/fixtures/arts-books.html")
      
      #Fakeweb: allow only one url to be fetched from web. If all are allowed, it is difficult to test
      FakeWeb.allow_net_connect = /9709726315/ 
      FakeWeb.register_uri(:get, ::APP_CONFIG['flipkart_url'], 
                           :body => main_page, 
                           :content_type => 'text/html')                 
      FakeWeb.register_uri(:get, 'http://www.flipkart.com/m/arts-photography-and-design-books-2', 
                           :body => books_list, 
                           :content_type => 'text/html')     
                                           
      Scraper::FlipkartCrawler.fetch_content                        
    
      expected_csv = File.read("#{base_path}/spec/fixtures/expected_flipkart_data.csv")
      generated_csv = File.read("#{base_path}/data/flipkart_books.csv")
      
      #Not sure if this is the best way to test this
      expected_csv == generated_csv
    end
  end
  
  describe "scraping uk cities from wiki page" do
    it "should look for url 'http://en.wikipedia.org/wiki/List_of_towns_in_England'" do
      ::APP_CONFIG['wiki_url'].should =~ /wiki\/List_of_towns_in_England/
    end
    
    it "should parse and store the content of a book with ISBN 9709726315, in csv" do
      wiki_page = File.read("#{base_path}/spec/fixtures/uk_towns_wiki.html")
  
 
      FakeWeb.register_uri(:get, ::APP_CONFIG['wiki_url'], 
                           :body => wiki_page, 
                           :content_type => 'text/html')                 
 
                                           
      Scraper::WikiScraper.fetch_content                        
    
      expected_csv = File.read("#{base_path}/spec/fixtures/expected_wiki_data.csv")
      generated_csv = File.read("#{base_path}/data/uk_cities.csv")
      
      #Not sure if this is the best way to test this
      expected_csv == generated_csv
    end
  end
    
  describe "rake task" do
    let(:rake) {Rake::Application.new}
        
    before(:each) do
      Rake.application = rake
      Rake.application.rake_require('scraper', ["#{ File.expand_path(File.join(File.dirname(__FILE__), '..', 'tasks' ))}"])
    end
    
    it 'should have a task to crawl flipkart' do
      pending()   
    end
    
    it 'should have a task to scrape wiki' do
      pending()   
    end
  end
 
  
end
