#!/usr/bin/env ruby

%%{

machine test;

action hold {
  args = [fpc, fc.chr, fc, fcurs, ftargs]
  puts "#%02d %s %3d %2d->%2d fhold" % args
  fhold;
}

action call_expr {
  args = [fpc, fc.chr, fc, fcurs, ftargs]
  puts "#%02d %s %3d %2d->%2d fcall ref_expr" % args
  fhold;
  fcall ref_expr;
}

action ret {
  args = [fpc, fc.chr, fc, fcurs, ftargs]
  puts "#%02d %s %3d %2d->%2d fret" % args
  fhold;
  fret;
}

action error {
  args = [fpc, fc.chr, fc, fcurs, ftargs]
  puts "#%02d %s %3d %2d->%2d error" % args
}

action var {
  args = [fpc, fc.chr, fc, fcurs, ftargs]
  puts "#%02d %s %3d %2d->%2d variable" % args
}

action num {
  args = [fpc, fc.chr, fc, fcurs, ftargs]
  puts "#%02d %s %3d %2d->%2d number" % args
}

action op {
  args = [fpc, fc.chr, fc, fcurs, ftargs]
  puts "#%02d %s %3d %2d->%2d op" % args
}

action expr_op {
  args = [fpc, fc.chr, fc, fcurs, ftargs]
  puts "#%02d %s %3d %2d->%2d expr_op" % args
}

call_expr = any >call_expr >/call_expr;
ret = any >ret >/ret;

var = alpha* $var;
num = [0-9]* $num;
op = ("+" | "-" | "*" | "/") $op;

expr_op = ("("  call_expr op call_expr ")") $expr_op;
expr = expr_op | var | num;

all = call_expr* :> space*;

main := all $!error;

ref_expr := expr $!ret;

}%%

%% write data;

def run_machine(data)
  eof = pe = data.length
  stack = []
  top = 0
  data = data.unpack("c*") if data.is_a?(String)
  %% write init;
  %% write exec;
end

data=File.open(File.dirname(__FILE__)+"/data") { |f| f.read }
puts data
run_machine(data)

