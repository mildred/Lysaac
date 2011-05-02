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
  @ll_file = "#{cluster}.ll"
  @bc_file = "#{cluster}.bc"
  cmd="#{$homedir}/bin/lysaac.cov compile '#{cluster}' >'#{@ll_file}'"
  system(cmd)
  @cmd_code = $?
  if $? != 0 then
    puts cmd
    File.open(@ll_file, 'r') { |f| puts f.read() }
    $?.should == 0
  end
  system("llvm-as <'#{@ll_file}' >'#{@bc_file}'")
  if $? != 0 then
    puts "Failure: see LLVM source in: #{FileUtils.pwd()}/#{@ll_file}"
    $?.should == 0
  end
  @cmd_text = `lli <'#{@bc_file}'`;
  @cmd_code = $?
end

Then /^I should see$/ do |string|
  @cmd_text.gsub(FileUtils.pwd(), "$CWD").should == string
end

