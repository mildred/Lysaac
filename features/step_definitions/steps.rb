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
  @ll_file = "#{cluster}.ll"
  @bc_file = "#{cluster}.bc"
  @er_file = "#{cluster}.err"
  @cmd = "#{$homedir}/bin/lysaac.cov #{action} '#{cluster}' >'#{@ll_file}' 2>'#{@er_file}'"
  system(@cmd)
  @cmd_code = $?
  @cmd_text = File.open(@ll_file, 'r').read()
  if action == "compile" then
    system("llvm-as <'#{@ll_file}' >'#{@bc_file}'")
    if $? != 0 then
      puts "==> #{@er_file}"
      File.open(@er_file, 'r') { |f| puts f.read() }
      puts "==> #{@ll_file}"
      puts @cmd_text
      puts "==> [#{@cmd_code}] #{@cmd}"
      puts "==> [#{$?}] llvm-as <'#{@ll_file}' >'#{@bc_file}'"
      $?.should == 0
    end
  end
end

When /^I execute the cluster "([^"]*)"$/ do |cluster|
  When %Q{I compile the cluster "#{cluster}"}
  if @cmd_code != 0 then
    puts "==> #{@er_file}"
    File.open(@er_file, 'r') { |f| puts f.read() }
    puts "==> #{@ll_file}"
    File.open(@ll_file, 'r') { |f| puts f.read() }
    puts "==> [#{@cmd_code}] #{@cmd}"
    @cmd_code.should == 0
  end
  @cmd = "lli <'#{@bc_file}'"
  @cmd_text = `#{@cmd}`;
  @cmd_code = $?
end

Then /^I should see$/ do |string|
  @cmd_text.gsub(FileUtils.pwd(), "$CWD").should == string
end

# This step cannot appear in a Background block because of issue 52:
# https://github.com/cucumber/cucumber/issues/52
Given /^the following prototypes in "([^"]*)":$/ do |dir, table|
  FileUtils.mkdir_p(dir)
  table.rows.each do |proto|
    f = "#{$resourcedir}/#{proto[0].downcase}.li";
    if File.exists?(f) then
      FileUtils.copy(f, "#{dir}");
    else
      raise Exception, "Unknown prototype #{proto} in #{$resourcedir}"
    end
  end
end

Then /^I should have the errors$/ do |expected_table|
  got_table = Cucumber::Ast::Table.new(parse_errors(@er_file))
  got_table.diff! expected_table
end

Then "I shouldn't have any errors" do
  e = parse_errors(@er_file)
  if e.length > 0 then
    raise Exception, ("Got #{e.length} errors:\n" + (e.map do |line|
      "#{line[0]}:#{line[1]}:#{line[2]}: #{line[3]}\n"
    end.join))
  end
end

