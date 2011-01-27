%%{
# http://www.complang.org/ragel/


machine Lysaac;

file = BOM? ws program;

program = section*;

section = "Section" ws section_name ws slot* ws;
section_name = "Header" | "Public" | "Private";

slot = slot_style ws ";" ws;
slot_style = [+-];

ws = (EOL | space)*;
EOL = ('\n' | '\r\n' | '\r') @inc_line_number;
BOM = 0xEF 0xBB 0xBF; # http://en.wikipedia.org/wiki/Byte_order_mark

%%}

