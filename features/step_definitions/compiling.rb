$: << File.join(File.expand_path(File.dirname(__FILE__)), "..", "..", "lib")

require 'tmpdir'
require 'cluster'
require 'compiler'

Before do
  @dir = Dir.mktmpdir()
  @compiler = nil
end

After do
  FileUtils.rm_rf(@dir)
end

Given /^a file "([^"]*)"$/ do |file, content|
  File.open(File.join(@dir, file), 'w') { |f| f.write(content) }
end

When /^I compile "([^"]*)"$/ do |proto|
  @compiler = Compiler.new(Cluster.new(@dir))
  @result = @compiler.compile(proto)
end

Then /^it should execute to$/ do |string|
  @result.execute().should == string
end
