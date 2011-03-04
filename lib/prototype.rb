require 'parser'

class Prototype
  attr_reader :path
  attr_reader :source_text
  attr_reader :name
  attr_reader :slots

  @@parser = Lysaac::RbParser.new()

  def initialize(path)
    @path = path
    @slots = []
    @name = ""
    File.open(@path) { |f| @source_text = f.read }
    @@parser.scan(@source_text, self)
  end

  def add_slot(slot)
    @slots << slot
  end
end
