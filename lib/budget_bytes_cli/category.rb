class BudgetBytesCli::Category
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
        first_page = Nokogiri::HTML(open(self.url))
        
        page_nums = first_page.css(".page-numbers")
        if page_nums.empty?
            pages_total = 1
        else
            pages_total = page_nums.map{|p| p.text.to_i}.max
        end
        
        get_recipes_from(self.url)
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
end
