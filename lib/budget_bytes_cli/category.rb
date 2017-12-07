class BudgetBytesCli::Category
    attr_reader :url, :name
    
    @@all = []
    
    def self.all
        @@all
    end
    
    def initialize(url = nil, name = nil)
        @name = name
        @url = url
        @@all << self
    end
    
    def recipes
        @recipes = BudgetBytesCli::Scraper.get_recipes(self.url) unless @recipes
        
        @recipes
    end
 
    def combine_recipes(cat_to_combine)
        recipes_combined = cat_to_combine.recipes
        recipe_urls = self.recipes.map {|r| r.url}
        recipes_combined.select {|r| recipe_urls.include?(r.url)}
    end
end
