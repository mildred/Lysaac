require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

file "lib/parser.rb" => ["ragel/common.rl", "ragel/parser.rb.rl"] do
  sh "ragel -R ragel/parser.rb.rl -o lib/parser.rb"
end

