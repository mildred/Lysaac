require 'parser'

class Prototype
  attr_reader :path
  attr_reader :source_text
  attr_reader :name
  attr_reader :slots

  @@parser = Lysaac::RbParser.new()

  def initialize(path)
    @path = path
    @sections = []
    @name = ""
    File.open(@path) { |f| @source_text = f.read }
    @@parser.scan(@source_text, self)
    puts to_s
  end

  def add_section(section)
    @sections << section
  end
  
  def to_s
    @sections.map { |s| s.to_s }.join("\n\n")
  end
end
