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
        self.get_recipes unless @recipes
        @recipes
    end
    
    def get_recipes
        @recipes = []
        first_page = Nokogiri::HTML(open(self.url))
        
        page_nums = first_page.css(".page-numbers")
        if page_nums.empty?
            pages_total = 1
        else
            pages_total = page_nums.map{|p| p.text.to_i}.max
        end
        
        (1..pages_total).each do |p|
            get_recipes_from(create_page_url(p))
        end
    end
    
    def get_recipes_from(page_url)
        recipe_page = Nokogiri::HTML(open(page_url))
        recipe_links = recipe_page.css(".archive-post a")
        recipe_links.each do |r|
            recipe_title = r.attribute("title").value
            recipe_url = r.attribute("href").value
            @recipes << BudgetBytesCli::Recipe.new(recipe_url, recipe_title)
        end
    end
    
    def create_page_url(num)
        if num == 1
            self.url
        else
            self.url + "page/" + num.to_s + "/"
        end
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
