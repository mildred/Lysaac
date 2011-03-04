%%{
# http://www.complang.org/ragel/


machine lysaac_common;


action ret { puts :ret; puts fc.chr; fret; }
action call_instr_list { puts :call_instr_list; fcall list_content; }

EOL = ('\n' | '\r\n' | '\r') %inc_line_number %reset_col_number;
BOM = 0xEF 0xBB 0xBF; # http://en.wikipedia.org/wiki/Byte_order_mark
ws = (EOL | space)*;

keyword = ([A-Z][a-z]("_" [A-Za-z0-9]|[A-Za-z0-9])*) >~r_keyword $c_keyword;
identifier = ([a-z]("_" [a-z0-9]|[a-z0-9])*) >~r_identifier $c_identifier;
protoname = ([A-Z]("_" [A-Z0-9]|[A-Z0-9])*) >~r_protoname $c_protoname;

keywords = (keyword %keywords ws)* >~r_keywords;

slot_style = [+\-] >style;
affect = (":=" | "<-") >affect;



constant = protoname %cst_proto;

list = "(" @call_instr_list any ws ")" @{puts :end_list} ws;
block = "{" @call_instr_list any ws "}" ws;
contract = "[" @call_instr_list any ws "]" ws;

expr_internal = "Internal" >{puts :internal} [^;]*;

expr = (constant >{puts :constant} | list | expr_internal) ws;

slot = slot_style ws identifier ws affect ws expr ws @test ";" @test ws;

instr = expr ws ";" ws;

list_content := ws instr* $~inc_col_number $!ret;

section_name = "Public" | "Private";
section = "Section" ws section_name ws slot* @{puts :end} ws;

slot_header = slot_style ws identifier ws affect ws keywords ws %slot_header_def ws constant %slot_header_value ws ";" ws;

section_header = "Section" ws "Header" ws slot_header* ws;
section_any = section | section_header;

program = section_any*;

file =  BOM? %reset_col_number ws program ws;

main := file $~inc_col_number $!error;

}%%

