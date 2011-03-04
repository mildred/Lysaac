require 'result'
require 'prototype'

class Cluster
  attr_reader :path
  attr_reader :files

  def initialize(path)
    @path  = Dir.new(File.expand_path(path))
    @files = []
    @types = {}
    parse(@path)
  end

  def parse(path = nil)
    if not path.nil? and path.is_a?(String) then
      path = Dir.new(path)
    end
    dirs = []
    has_source = false
    path.each do |filename|
      next if filename == '.' or filename == '..'
      f = File.join(path.path, filename)
      dirs << f if File.directory?(f)
      if source?(filename) then
        insert_source(f)
        has_source = true
      end
    end
    if has_source then
      dirs.each do |dir|
        parse(dir)
      end
    end
  end
  
  def source?(filename)
    filename =~ /\.li$/
  end
  
  def insert_source(path)
    @files << path
    type = File.basename(path).sub(/\.li$/, "").upcase
    unless @types[type].nil? then
      raise Exception, "Type #{type} appears twice in cluster '#{@path}':\n\t#{@types[type]}\n\t#{path}"
    else
      @types[type] = path
    end
  end
  
  def prototype(name)
    return nil if @types[name].nil?
    Prototype.new(@types[name])
  end

  def compile(name)
    p = prototype(name)
    Result.new
  end
end

