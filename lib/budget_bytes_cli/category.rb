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
        @recipes = BudgetBytesCli::CategoryScraper.get_recipes(self.url) unless @recipes
        
        @recipes
    end
 
    def combine_recipes(cat_to_combine)
        recipes_combined = cat_to_combine.recipes
        recipe_urls = self.recipes.map {|r| r.url}
        filtered_recipes = recipes_combined.select do |r|
            recipe_urls.include?(r.url)
        end
        filtered_recipes
    end
end
