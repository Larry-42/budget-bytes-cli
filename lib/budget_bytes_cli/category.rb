class BudgetBytesCli::Catgeory
    attr_reader :url, :name
    
    @@all = []
    
    def self.all
        @@all
    end
    
    def initialize(url = nil, name = nil)
        @name = name
        @url = url
        @@all << self
    end
end
