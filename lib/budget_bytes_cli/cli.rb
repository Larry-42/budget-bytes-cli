class BudgetBytesCli::CLI
    
    def call
        puts "Welcome to Budget Bytes CLI!"
        scraper = BudgetBytesCli::CategoryScraper.new
        scraper.create_categories
        category_selector = BudgetBytesCli::ArrayPrompter.new
        category_selector.array_to_select = BudgetBytesCli::Category.all.map {|i| i.name}
        category_selector.prompt_text = "Selecting recipe category."
        
        recipe_selector = BudgetBytesCli::ArrayPrompter.new
        
        current_selector = category_selector
        selection = category_selector.get_input
        
        while selection != 'Q'
            if current_selector == category_selector
                selected_category = BudgetBytesCli::Category.all[selection.to_i - 1]
                display_num_recipes(selected_category)
                selection = category_selector.get_input
            end
        end
    end
    
    def display_num_recipes(category_chosen)
        unless category_chosen.recipes
            category_chosen.get_recipes
        end
        
        num_recipes = category_chosen.recipes.length
        
        puts "You picked #{category_chosen.name}."        
        puts "There are #{num_recipes} recipes in this category."
    end
end
