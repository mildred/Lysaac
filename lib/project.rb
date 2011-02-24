require 'result'

class Project
  attr_accessor :dir

  def initialize
    @dir = nil
  end

  def compile(path)
    Result.new
  end
end
