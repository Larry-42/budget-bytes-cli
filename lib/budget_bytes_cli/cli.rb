class BudgetBytesCli::CLI
    
    def call
        puts "Welcome to Budget Bytes CLI!"
        scraper = BudgetBytesCli::CategoryScraper.new
        scraper.create_categories
        category_selector = BudgetBytesCli::ArrayPrompter.new("Selecting recipe category.")
        category_selector.array_to_select = BudgetBytesCli::Category.all.map {|i| i.name}
        
        recipe_selector = BudgetBytesCli::ArrayPrompter.new("Selecting recipe")
        
        cat_combination_selector = BudgetBytesCli::ArrayPrompter.new("Selecting category to combine.")
        
        current_selector = category_selector
        selection = category_selector.get_input
        
        #define variables outside of while loop scope
        selected_category = nil
        filtered_recipes = []
        
        while selection != 'Q'
            if current_selector == category_selector
                selected_category = BudgetBytesCli::Category.all[selection.to_i - 1]
                whether_to_combine = yes_no_input("Combine with another category?  In other words, display only recipes in both the current category and another you select?")
                if whether_to_combine == 'Y'
                    #TODO:  ADD CODE TO COMBINE RECIPES, SET SELECTOR TO cat_combination_selector
                else
                    current_selector = recipe_selector
                    recipe_selector.array_to_select = selected_category.recipes.map {|i| i.name}
                end
            else
                selected_recipe = selected_category.recipes[selection.to_i - 1]
                self.display_recipe(selected_recipe)
                current_selector = category_selector
            end
            selection = current_selector.get_input
        end
    end
    
    def display_recipe(recipe_chosen)
        puts recipe_chosen.name
        puts "\nIngredients\n"
        puts recipe_chosen.ingredients
        puts ""
        page_width = IO.console.winsize[1]
        puts reformat_wrapped(recipe_chosen.instructions, page_width || 80)
        puts ""
        if yes_no_input("Do you want to open this recipe in your browser?") == 'Y'
            Launchy.open(recipe_chosen.url)
        end
    end
    
    def yes_no_input (prompt)
        puts prompt + " Please answer 'y' or 'n'"
        input = gets.strip.upcase
        while !['Y', 'N'].include?(input)
            puts "Invalid input."
            puts prompt + " Please answer 'y' or 'n'" 
            input = gets.strip.upcase
        end
        input
    end
    
    #from https://www.safaribooksonline.com/library/view/ruby-cookbook/0596523696/ch01s15.html
	def reformat_wrapped(s, width= 78)
	  lines = []
	  line = ""
	  s.split(/\s+/).each do |word|
	    if line.size + word.size >= width
	      lines << line
	      line = word
	    elsif line.empty?
	     line = word
	    else
	     line << " " << word
	   end
	   end
	   lines << line if line
	  return lines.join "\n"
	end
end
