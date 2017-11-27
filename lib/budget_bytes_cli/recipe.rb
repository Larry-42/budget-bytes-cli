class BudgetBytesCli::Recipe
    attr_reader :url, :name
    
    def initialize(url = nil, name = nil)
        @name = name
        @url = url
    end
    
    def scrape_recipe
        page = Nokogiri::HTML(open(@url))
        
        ingredient_amounts = page.css('.wprm-recipe-ingredient-amount').map {|i| i.text}
        ingredient_units = page.css('.wprm-recipe-ingredient-unit').map {|i| i.text}
        ingredient_names = page.css('.wprm-recipe-ingredient-name').map {|i| i.text}
        
        ingredient_array = []
        
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
        
        #scraping for old site before css switched to have recipe instructions in own class
        page.css("p").map {|i| i.text}.each do |p|
            if p.split(" ")[0] == "STEP"
                recipe_steps << p.split(" ").slice(2, p.length - 2).join(" ")
            end
        end
        
        page.css(".wprm-recipe-instruction-text").each {|i| recipe_steps << i.text}

        @ingredients = ingredient_array.join("\n")
        @instructions = recipe_steps.join("\n")
    end
    
    def ingredients
        self.scrape_recipe unless @ingredients
        @ingredients
    end
    
    def instructions
        self.scrape_recipe unless @instructions
        @instructions
    end
    
end
