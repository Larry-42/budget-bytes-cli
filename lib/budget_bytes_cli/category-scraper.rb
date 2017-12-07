class BudgetBytesCli::CategoryScraper
    
    #functions for getting categories
    def self.open_page
        Nokogiri::HTML(open("https://www.budgetbytes.com/recipes/"))
    end
    
    def self.locate_categories
        open_page.css(".cat-item")
    end
    
     def self.create_categories
        locate_categories.each do |item|
            url = item.css("a").attribute("href").value
            title = item.css("a").children[0].text
            BudgetBytesCli::Category.new(url, title)
        end
    end
    
    #functions for scraping recipes within a category
    def self.get_recipes(url)
        first_page = Nokogiri::HTML(open(url))
        
        page_nums = first_page.css(".page-numbers")
        if page_nums.empty?
            pages_total = 1
        else
            pages_total = page_nums.map{|p| p.text.to_i}.max
        end
        
        (1..pages_total).map {|p|get_recipes_from(create_page_url(p, url))}.flatten
    end
    
    def self.get_recipes_from(page_url)
        recipe_page = Nokogiri::HTML(open(page_url))
        recipe_links = recipe_page.css(".archive-post a")
        
        recipe_links.map do |r|
            recipe_title = r.attribute("title").value
            recipe_url = r.attribute("href").value
            BudgetBytesCli::Recipe.new(recipe_url, recipe_title)
        end
    end
    
    def self.create_page_url(num, url)
        if num == 1
            url
        else
            url + "page/" + num.to_s + "/"
        end
    end
end
