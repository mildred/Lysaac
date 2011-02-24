%%{
# http://www.complang.org/ragel/


machine Lysaac_common;

EOL = ('\n' | '\r\n' | '\r') @inc_line_number;
BOM = 0xEF 0xBB 0xBF; # http://en.wikipedia.org/wiki/Byte_order_mark
ws = (EOL | space)*;

slot_style = [+\-];
slot = slot_style ws ";" ws;

section_name = "Header" | "Public" | "Private";
section = "Section" ws section_name ws slot* ws;

program = section*;

file = BOM? ws program;

main = file;

}%%

