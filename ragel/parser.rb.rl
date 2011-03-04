require 'ast/slot'
require 'ast/prototype'

%%{
# http://www.devchix.com/2008/01/13/a-hello-world-for-ruby-on-ragel-60/

machine lysaac;

action inc_line_number {
  @line_number += 1
  puts "inc_line_number #{@line_number}"
}

action reset_col_number {
  @column_number = 1
  #puts "reset_col_number #{@column_number}"
}

action inc_col_number {
  @column_number += 1
  #puts "inc_col_number #{@column_number}"
}

action r_identifier {
  puts "r_identifier"
  @last_identifier = String.new
}

action c_identifier {
  @last_identifier << fc
  puts "c_identifier #{@last_identifier}"
}

action r_protoname {
  puts "r_protoname"
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
  warn "Error line #{@line_number}:#{@column_number}"
}

action test {
  puts "test #{@line_number}:#{@column_number}"
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

      @line_number   = 1
      @column_number = 1
      @prototype     = prototype

      # Ragel init
      %% write init;

      # Ragel exec
      %% write exec;
    end

  end
end
