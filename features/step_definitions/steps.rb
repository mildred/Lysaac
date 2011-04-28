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

When /^I set ([a-zA-Z0-9_]+)="([^"]*)"$/ do |env, val|
  ENV[env]=val.gsub("$CWD", FileUtils.pwd())
end

When /^I (show|compile) the cluster "([^"]*)"$/ do |action, cluster|
  @cmd = "#{$homedir}/bin/lysaac.cov #{action} '#{cluster}'"
  @cmd_text = `#{@cmd}`;
  @cmd_code = $?
end

When /^I execute the cluster "([^"]*)"$/ do |cluster|
  @bc_file = "#{cluster}.bc"
  @cmd = "#{$homedir}/bin/lysaac.cov compile '#{cluster}' >'#{@bc_file}'"
  @cmd_text = `#{@cmd}`
  @cmd_code = $?
  if @cmd_code != 0 then
    puts "Failure: see LLVM source in: #{FileUtils.pwd()}/#{@bc_file}"
    puts @cmd_text
    @cmd_code.should == 0
  end
  @cmd = "cat '#{@bc_file}' | llvm-as | lli"
  @cmd_text = `#{@cmd}`;
  @cmd_code = $?
end

Then /^I should see$/ do |string|
  @cmd_text.gsub(FileUtils.pwd(), "$CWD").should == string
end

