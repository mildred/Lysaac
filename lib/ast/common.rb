module AST

  def conv_affect(str)
    case str
      when ':'  then ":="
      when '<'  then "<-"
      when '?'  then "?="
      when ":=" then ':'
      when "<-" then '<'
      when "?=" then '?'
    end
  end

end
