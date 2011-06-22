require 'spec/expectations'
require 'fileutils'

$initcurrentdir = FileUtils.pwd
$homedir = File.dirname(File.dirname(File.dirname(__FILE__)))
$resourcedir = File.dirname(File.dirname(__FILE__)) + "/resources"
$tmpdir = File.join($homedir, "tmp", "null")

def cd_in_unique_dir
  dir = if $scenariodir.nil? then $tmpdir else $scenariodir end
  if FileUtils.pwd != dir then
    FileUtils.rm_rf dir
    FileUtils.mkdir_p dir
    FileUtils.cd dir
  end
end
