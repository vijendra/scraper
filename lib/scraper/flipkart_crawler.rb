module Scraper

  class FlipkartCrawler

    def self.fetch_content
      url = ::APP_CONFIG['flipkart_url']
      prepare_csv
      Anemone.crawl(url, :threads => 4) do  |anemone|
        anemone.on_pages_like(/flipkart.com\/m\/[^?]*$/) do |page|
         parse_page(page)  
        end  
      end  
    end  
    
    private
    
    def self.prepare_csv
      csv_path = File.expand_path(File.dirname(__FILE__)).to_s.gsub('/scraper/lib', '') #FIXME. Find some better way
      @csv = CSV.open("#{csv_path}/data/flipkart_books.csv", "wb")
      @csv << ['ISBN/PID', 'TITLE', 'URL', 'PRICE' ]
    end
    
    def self.parse_page(page)
      url = ::APP_CONFIG['flipkart_url']
      #If it is a product page parse it
      unless page.doc.nil?
        unless page.doc.at_css(".product_page_title h1").nil? 
          isbn = page.url.to_s.gsub("#{url}/", '')
          price = page.doc.at_css('#productpage-price span').text
           
          title = page.doc.at_css('.product_page_title h1').text
          insert_to_csv([isbn, title, page.url.to_s, price])
        end 
      end    
    end
    
    def self.insert_to_csv(value_array)
      @csv << value_array
    end
  
  end  
  
end
