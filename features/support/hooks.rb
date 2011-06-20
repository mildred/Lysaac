require 'fileutils'

Before do
  ENV['LYSAAC_PATH'] = nil
  $oldcurrentdir = FileUtils.pwd
  dir = File.join($homedir, "tmp", "null")
  FileUtils.rm_rf dir
  FileUtils.mkdir_p dir
  FileUtils.cd(dir)
end

Around do |scenario, block|
  dir = File.join($homedir, "tmp", scenario.file_colon_line.gsub(/[\/\\:]/, "."))
  FileUtils.rm_rf dir
  FileUtils.mkdir_p dir
  FileUtils.cd(dir) do
    block.call
  end
  FileUtils.cd $oldcurrentdir
  if scenario.failed?
    puts "Leftover files in #{dir}"
  else
    #FileUtils.rm_rf dir
  end
end
