require 'project'

class Compiler
  attr_reader :project

  def initialize()
    @project = Project.new
  end

  def compile(path)
    project.compile(path)
  end
end
