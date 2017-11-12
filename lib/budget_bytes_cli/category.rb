class BudgetBytesCli::Catgeory
    #TODO:  Remove num_pages (only there as placehodler!)
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
        #To enable scraping of pages
        page_nums = recipe_page.css(".page-numbers")
        pages_total = 0
        if page_nums.empty?
            pages_total = 1
        else
            pages_total = page_nums.map{|p| p.text.to_i}.max
        end
        
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
