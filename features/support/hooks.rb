require 'fileutils'

Before do
  ENV['LYSAAC_PATH'] = nil
  cd_in_unique_dir
end

Around do |scenario, block|
  if scenario.respond_to? :scenario_outline then
    name = scenario.scenario_outline.file_colon_line + ':' + scenario.line.to_s
  else
    name = scenario.file_colon_line
  end
  $scenariodir = File.join($homedir, "tmp", name.gsub(/[\/\\:]/, "."))
  cd_in_unique_dir
  block.call
  if scenario.failed?
    puts "Leftover files in #{$scenariodir}"
  else
    #FileUtils.rm_rf $scenariodir
  end
  $scenariodir = nil
end

After do
  FileUtils.cd $initcurrentdir
end
