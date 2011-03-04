class Compiler
  attr_reader :cluster

  def initialize(cluster)
    @cluster = cluster
  end

  def compile(name)
    cluster.compile(name)
  end
end
