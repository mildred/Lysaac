require 'fileutils'

Before do
  ENV['LYSAAC_PATH'] = nil
  cd_in_unique_dir
end

Around do |scenario, block|
  $scenariodir = File.join($homedir, "tmp", scenario.file_colon_line.gsub(/[\/\\:]/, "."))
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
