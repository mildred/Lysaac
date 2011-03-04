require 'ast/common'

module AST

  class Slot
    attr_accessor :name
    attr_accessor :style
    attr_accessor :affect
    attr_accessor :affect_keywords
    attr_accessor :value

    def initialize()
    end
    
    def to_s
      "#{style} #{name} #{conv_affect(affect)} #{affect_keywords.join(' ')} #{value};"
    end
  end

end
