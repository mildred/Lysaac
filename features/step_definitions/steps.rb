require 'fileutils'

Given /^a file "([^"]*)"$/ do |file|
  FileUtils.mkdir_p(File.dirname(file))
  FileUtils.touch(file)
end

Given /^a file "([^"]*)" with$/ do |file, content|
  FileUtils.mkdir_p(File.dirname(file))
  File.open(file, "w") do |f|
    f.write(content)
    f.flush()
  end
end

When /^I run lysaac (.*)$/ do |args|
  @cmd = "#{$homedir}/bin/lysaac.cov #{args}"
  @cmd_text = `#{@cmd}`;
end

Then /^I should see$/ do |string|
  @cmd_text.should == string
end

