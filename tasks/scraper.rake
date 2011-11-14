namespace :scraper do
  task :fetch_flipkart do 
    Scraper::FlipkartScraper.fetch_content 
  end
end
