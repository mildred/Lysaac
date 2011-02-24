require 'tmpdir'
require 'compiler'

Before do
  @dir = Dir.mktmpdir()
  @compiler = Compiler.new
  @compiler.project.dir = @dir
end

After do
  FileUtils.rm_rf(@dir)
end

Given /^a file "([^"]*)"$/ do |file, content|
  f = File.new(File.join(@dir, file), 'w')
  f.write (content)
  f.close
end

When /^I compile "([^"]*)"$/ do |proto|
  @result = @compiler.compile(proto)
end

Then /^it should execute to$/ do |string|
  @result.execute().should == string
end
