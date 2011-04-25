require 'fileutils'

Around do |scenario, block|
  dir = File.join("tmp", scenario.file_colon_line.gsub(/[\/\\:]/, "."))
  FileUtils.rm_rf dir
  FileUtils.mkdir_p dir
  $homedir = File.dirname(File.dirname(File.dirname(__FILE__)))
  FileUtils.cd(dir) do
    block.call
  end
  if scenario.failed?
    puts "Leftover files in #{dir}"
  else
    FileUtils.rm_rf dir
  end
end
