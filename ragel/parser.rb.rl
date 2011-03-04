require 'ast/slot'
require 'ast/prototype'
require 'ast/internal'

%%{
# http://www.devchix.com/2008/01/13/a-hello-world-for-ruby-on-ragel-60/

machine lysaac;

action line_break {
  register_line_break(fpc)
  coords = coords_for(fpc)
  puts "#{coords.join(':')}: line_break"
}

action r_identifier {
  c = fc
  puts "r_identifier #{c.chr}"
  @last_identifier = String.new
}

action c_identifier {
  @last_identifier << fc
  puts "c_identifier #{@last_identifier}"
}

action r_protoname {
  c = fc
  puts "r_protoname #{c.chr}"
  @last_protoname = String.new
}

action c_protoname {
  @last_protoname << fc
  puts "c_protoname #{@last_protoname}"
}

action r_keyword {
  @last_keyword = String.new
}

action c_keyword {
  @last_keyword << fc
  puts "c_keyword #{@last_keyword}"
}

action r_keywords {
  @last_keywords = []
  puts "r_keywords"
}

action keywords {
  @last_keywords << @last_keyword.intern
}

action cst_proto {
  @last_constant = AST::Prototype.new(@last_protoname.intern)
}

action cst_internal {
  puts :Internal
  @last_constant = AST::Internal.new
}

action affect {
  @last_affect = fc.chr
  puts "affect #{@last_affect}"
}

action style {
  @last_style = fc.chr
  puts "style #{@last_style}"
}

action slot_header_def {
  @last_slot = AST::Slot.new
  @last_slot.name = @last_identifier.intern
  @last_slot.style = @last_style.intern
  @last_slot.affect = @last_affect.intern
  @last_slot.affect_keywords = @last_keywords
}

action slot_header_value {
  @last_slot.value = @last_constant
}

action error {
  coords = coords_for(fpc)
  warn "Error line #{coords.join(':')}"
}

action test {
  coords = coords_for(fpc)
  c = fc
  puts "#{coords.join(':')}: test #{c} '#{c.chr}'"
}

include lysaac_common "common.rl";

}%%

module Lysaac
  class RbParser

    def initialize()
      # Ragel data
      %% write data;
    end

    def scan(data, prototype)
      eof = pe = data.length
      data = data.unpack("c*") if data.is_a?(String)
      stack = []
      top = 0

      @prototype     = prototype
      @line_breaks   = []

      # Ragel init
      %% write init;

      # Ragel exec
      %% write exec;
    end
    
    def register_line_break(i)
      if @line_breaks.index(i).nil? then
        @line_breaks << i
      end
    end
    
    def coords_for(i)
      line_num   = 1
      last_break = 0
      @line_breaks.each do |br|
        if br <= i then
          line_num  += 1
          last_break = [last_break, br].max
        end
      end
      col_num = i - last_break + 1
      #puts "coords_for(#{i}) #{line_num}:#{col_num} [#{@line_breaks.join(',')}]"
      [line_num, col_num]
    end

  end
end
