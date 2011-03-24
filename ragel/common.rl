%%{
# http://www.complang.org/ragel/


machine lysaac_common;

# Stack Managment

action call_expr { puts :call_expr; fhold; fcall ref_expr; }
action ret { puts :ret; fhold; fret; }
action hold { fhold; }

none = any @hold;

call_expr = any >test >call_expr >/call_expr;

################################################################################
# Lexer

EOL = ('\n' | '\r\n' | '\r') %line_break;
BOM = 0xEF 0xBB 0xBF; # http://en.wikipedia.org/wiki/Byte_order_mark
ws = (EOL | ' ' | '\t')*;

keyword = ([A-Z][a-z]("_" [A-Za-z0-9]|[A-Za-z0-9])*) >~r_keyword $c_keyword;
identifier = ([a-z]("_" [a-z0-9]|[a-z0-9])*) >~r_identifier $c_identifier;
protoname = ([A-Z]("_" [A-Z0-9]|[A-Z0-9])*) >~r_protoname $c_protoname;

keywords = (keyword %keywords ws)* >~r_keywords;

slot_style = [+\-] >style;
affect = (":=" | "<-") >affect;

################################################################################
# Parser

##### Constant #####

cst_string_escape = ws '\\';
cst_string   = '"' ( ^["\\\r\n] | '\\' cst_string_escape | EOL )* '"' @test ;
cst_internal = "Internal" %cst_internal;
cst_proto    = protoname %cst_proto;
cst_integer  = [0-9]+;

constant = cst_internal | cst_proto | cst_integer | cst_string;

##### Expression #####

## Group

group = call_expr ws (";" ws call_expr)* :> ws;
expr_list = "(" ws <: group %{puts :end_group} ws ")" ws;
expr_block = "{" ws <: group ws "}" ws;
expr_contract = "[" ws <: group ws "]" ws;

## Send Message

expr_send_msg = identifier ws <: call_expr? :> ws;

## Other

expr_base = constant | expr_list | expr_send_msg;
expr = ws <: expr_base :> ws ('.' ws <: expr_send_msg :> ws)*;

##### Instruction #####

instr = expr ws ";" ws;

##### Slots #####

slot_header = slot_style ws identifier ws affect ws keywords %slot_header_def ws
              constant %slot_header_value ws ";" ws;

slot = slot_style ws identifier ws affect ws <: expr :> ws ";" ws;

##### Section #####

section_name = ("Public" %section_public | "Private" %section_private);
section = "Section" ws <: section_name :> ws <: slot* :> ws;

section_header = "Section" ws "Header" %section_header ws <: slot_header* :> ws;
section_any = section | section_header;

program = section_any*;
file = BOM? ws <: program ws;

###############################################################################
# Entry Points

main := file $!error;

ref_expr := any @test @hold expr $!test $!ret;

}%%

