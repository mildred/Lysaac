# http://www.devchix.com/2008/01/13/a-hello-world-for-ruby-on-ragel-60/

module Lysaac
  class RbParser
    %%{
      machine Lysaac;

      action inc_line_number {
        @line_number += 1
      }

      include Lysaac_common "common.rl";
    }%%

    def initialize(listener)
      @listener = listener
      %% write data;
    end

    def scan(data)
      eof = pe = data.length
      data = data.unpack("c*") if data.is_a?(String)

      @line_number = 1

      %% write init;
      %% write exec;
    end
  end
end
