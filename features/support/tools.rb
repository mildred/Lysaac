def parse_errors(filename)
  got_table = []
  File.open(filename, 'r') do |f|
    f.lines.each do |line|
      cap = /(.*):(([0-9]+):(([0-9]+):)) (.*)/.match(line)
      if cap then
        got_table << [cap[1], (cap[3] or ""), (cap[5] or ""), cap[6]] if cap
        next
      else
        cap = /(.*):(([0-9]+):(([0-9]+):))? (.*)/.match(line)
      end
      if cap then
        got_table << [cap[1], (cap[3] or ""), (cap[5] or ""), cap[6]] if cap
        next
      else
        cap = /(.*):(([0-9]+):(([0-9]+):)?)? (.*)/.match(line)
      end
      got_table << [cap[1], (cap[3] or ""), (cap[5] or ""), cap[6]] if cap
    end
  end
  got_table
end

