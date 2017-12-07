class BudgetBytesCli::Scraper
    
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
    
    #scrape instructions, ingredients from recipe page
    def self.scrape_recipe(url)
        page = Nokogiri::HTML(open(url))
        
        ingredient_amounts = page.css('.wprm-recipe-ingredient-amount').map {|i| i.text}
        ingredient_units = page.css('.wprm-recipe-ingredient-unit').map {|i| i.text}
        ingredient_names = page.css('.wprm-recipe-ingredient-name').map {|i| i.text}
        
        ingredient_array = []
        
        #scraping ingredients for new site
        ingredient_amounts.each_with_index do |ele, idx|
            ingredient_array << [ele, ingredient_units[idx], ingredient_names[idx]].join(' ').strip
        end
        
        #scraping for old site before css switched so that the code above scrapes ingredients
        old_ingredients_table = page.css("tr")
        
        #get rid of first, last rows in table (header and total cost)
        old_ingredients_table.shift
        old_ingredients_table.pop 
        
        old_ingredients_table.each do |old_ingredient|
            old_ingredient_text = old_ingredient.text.split("\n")
            
            #get rid of first blank item, last cost item
            old_ingredient_text.shift
            old_ingredient_text.pop
            
            ingredient_array << old_ingredient_text.join(" ")
        end
        
        recipe_steps = []
        
        #scraping instructions for old site before css switched to have recipe instructions in own class
        page.css("p").map {|i| i.text}.each do |p|
            if p.split(" ")[0] == "STEP"
                recipe_steps << p.split(" ").slice(2, p.length - 2).join(" ")
            end
        end
        
        #scraping instructions for new site
        page.css(".wprm-recipe-instruction-text").each {|i| recipe_steps << i.text}

        [ingredient_array.join("\n"), recipe_steps.join("\n")]
    end
    
end
