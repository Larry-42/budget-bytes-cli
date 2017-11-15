#ArrayPrompter uses an ArraySelector for blocks of 20 (if needed) and
#an ArraySelector for the block of 20 chosen, returns the overall selection
class BudgetBytesCli::ArrayPrompter
    attr_accessor :prompt_text, :array_to_select
    
    def initialize
        @block_selector = BudgetBytesCli::ArraySelector.new
        @item_selector = BudgetBytesCli::ArraySelector.new
    end
    
    def get_input
        #TODO:  GET BLOCK INPUT!
        
        #Gets input using item_selector ArraySelector
        #TODO:  Change so that you select from the sub-block above.
        @item_selector.prompt_text = self.prompt_text
        @item_selector.array_to_select = self.array_to_select
        @item_selector.get_input
    end
end

#ArraySelector selects from an array (helper class for ArrayPrompter)
class BudgetBytesCli::ArraySelector
    attr_accessor :prompt_text, :array_to_select
    def last_item
        self.array_to_select.length
    end
    
    def prompt(text_prompt = nil)
        if text_prompt
            self.prompt_text = text_prompt
        end
        
        puts text_prompt
        self.array_to_select.each_with_index do |menu_item, idx|
            puts "#{idx + 1}.  #{menu_item}"
        end
        puts "Or enter 'Q' to quit"
    end
    
    def get_input
        input = ""
        valid_input = false
        while !valid_input
            self.prompt
            input = gets.strip.upcase
            if input == 'Q'
                valid_input = true        
            elsif input.to_i.to_s == input && input.to_i >= 0 && input.to_i <= self.last_item
                valid_input = true
            else
                puts "Invalid input, please try again."
            end
        end
        input
    end
end
