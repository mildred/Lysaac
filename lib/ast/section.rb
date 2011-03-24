module AST

  class Section
    def initialize(name)
      @slots = []
      @name  = name
    end
    
    def add_slot(slot)
      @slots << slot
    end

    def to_s
      "Section #{@name}\n\n" +
      @slots.map { |s| s.to_s }.join("\n")
    end
  end

end
