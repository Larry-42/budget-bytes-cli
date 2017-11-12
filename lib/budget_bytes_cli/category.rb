class BudgetBytesCli::Catgeory
    attr_reader :url, :name, :recipes
    
    @@all = []
    
    def self.all
        @@all
    end
    
    def initialize(url = nil, name = nil)
        @name = name
        @url = url
        @@all << self
    end
    
    def get_recipes
        @recipes = []
        recipe_page = Nokogiri::HTML(open(self.url))
        recipe_links = recipe_page.css(".archive-post a")
        recipe_links.each do |r|
            recipe_title = r.attribute("title").value
            recipe_url = r.attribute("href").value
            @recipes << BudgetBytesCli::Recipe.new(recipe_url, recipe_title)
        end
    end
end
