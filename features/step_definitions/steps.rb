require 'fileutils'

Given /^a file "([^"]*)"$/ do |file|
  FileUtils.mkdir_p(File.dirname(file))
  FileUtils.touch(file)
end

When /^I run lysaac (.*)$/ do |args|
  @cmd = "#{$homedir}/bin/lysaac #{args}"
  @cmd_text = `#{@cmd}`;
end

Then /^I should see$/ do |string|
  @cmd_text.should == string
end

