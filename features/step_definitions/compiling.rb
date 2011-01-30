require 'tmpdir'

Before do
  @dir = Dir.mktmpdir()
  @compiler = Compiler.new
  @compiler.set_project(@dir)
end

After do
  FileUtils.rm_rf(@dir)
end

Given /^a file "([^"]*)"$/ do |file, content|
  f = File.new(File.join(@dir, file))
  f.write (content)
end

When /^I compile "([^"]*)"$/ do |proto|
  @result = @compiler.compile(proto)
end

Then /^it should execute to$/ do |string|
  @result.execute()
end
