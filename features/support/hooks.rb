require 'fileutils'

Around do |scenario, block|
  ENV['LYSAAC_PATH'] = nil
  dir = File.join("tmp", scenario.file_colon_line.gsub(/[\/\\:]/, "."))
  FileUtils.rm_rf dir
  FileUtils.mkdir_p dir
  $homedir = File.dirname(File.dirname(File.dirname(__FILE__)))
  $resourcedir = File.dirname(File.dirname(__FILE__)) + "/resources"
  FileUtils.cd(dir) do
    block.call
  end
  if scenario.failed?
    puts "Leftover files in #{dir}"
  else
    #FileUtils.rm_rf dir
  end
end
