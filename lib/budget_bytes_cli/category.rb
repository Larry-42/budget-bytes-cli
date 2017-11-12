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
        #To enable scraping of pages
        #page_nums = recipe_page.css(".page-numbers")
        
        #TODO:  ADD ROBUST CODE TO FIND LAST PAGE NUMBER
        
        #only works if >=3 pages, I think...
        #last_page = page_nums[page_nums.length-2].text.to_i
        
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
