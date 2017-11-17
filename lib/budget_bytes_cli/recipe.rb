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
        
        ingredient_array = ingredient_amounts.each_with_index.map do |ele, idx|
            [ele, ingredient_units[idx], ingredient_names[idx]].join(' ').strip
        end

        @ingredients = ingredient_array.join("\n")
        @instructions = page.css(".wprm-recipe-instruction-text").map {|i| i.text}.join("\n")
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
