class BudgetBytesCli::Recipe
    attr_reader :url, :name
    
    def initialize(url = nil, name = nil)
        @name = name
        @url = url
    end
    
end
