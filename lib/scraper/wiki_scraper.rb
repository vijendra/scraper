module Scraper

  class WikiScraper

    def self.fetch_content
      url = ::APP_CONFIG['wiki_url']
      prepare_csv
      
      #Using screen scraping technique fetch the list of UK cities from wiki.
      doc = Nokogiri::HTML(open(url))  

      rows = doc.search('table')[1].search('tr')
      parse_wiki_page(rows)
    end  
    
    private
    
    def self.prepare_csv
      csv_path = File.expand_path(File.dirname(__FILE__)).to_s.gsub('/scraper/lib', '') #FIXME. Find some better way
      @csv = CSV.open("#{csv_path}/data/uk_cities.csv", "wb")
      @csv << ['County/Location', 'City/Town' ]
    end
    
    def self.parse_wiki_page(rows)
      (1 .. rows.count-1).each do |index|
        columns = rows[index].search('td')  unless rows[index].blank?
        location = parse_location(rows[index])
        city = parse_city(columns[0])
        self.insert_to_csv([location, city]) unless city.nil?
      end
    end
    
    def self.parse_location(row)
      row.search('td/text()').first.to_s unless row.blank?
    end
    
    def self.parse_city(columns)
       columns.search('a').inner_html.to_s  unless columns.blank?
    end
    
    def self.insert_to_csv(value_array)
      @csv << value_array
    end
  
  end  
  
end
