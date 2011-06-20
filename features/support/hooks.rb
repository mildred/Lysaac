require 'fileutils'

Before do
  ENV['LYSAAC_PATH'] = nil
  $oldcurrentdir = FileUtils.pwd
  dir = File.join($homedir, "tmp", "null")
  FileUtils.rm_rf dir
  FileUtils.mkdir_p dir
  FileUtils.cd dir
end

Around do |scenario, block|
  dir = File.join($homedir, "tmp", scenario.file_colon_line.gsub(/[\/\\:]/, "."))
  FileUtils.rm_rf dir
  FileUtils.mkdir_p dir
  FileUtils.cd(dir)
  block.call
  if scenario.failed?
    puts "Leftover files in #{dir}"
  else
    #FileUtils.rm_rf dir
  end
end

After do
  FileUtils.cd $oldcurrentdir
end
