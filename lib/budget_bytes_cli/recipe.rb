class BudgetBytesCli::Recipe
    attr_reader :url, :name
    
    def initialize(url = nil, name = nil)
        @name = name
        @url = url
    end
    
    def ingredients
        unless @ingredients
            @ingredients, @instructions = BudgetBytesCli::Scraper.scrape_recipe(@url)
        end
        @ingredients
    end
    
    def instructions
        unless @instructions
            @ingredients, @instructions = BudgetBytesCli::Scraper.scrape_recipe(@url) 
        end
        @instructions
    end
    
end
