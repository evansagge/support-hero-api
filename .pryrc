require 'colorize'

begin
  require 'fabrication'
  require 'ffaker'
rescue LoadError
end

app_name = 'Context'.colorize(:green).bold
environment_name = case ENV['RAILS_ENV']
when 'development'
  'development'.colorize(:light_blue)
when 'test'
  ENV['RAILS_ENV'].colorize(:light_blue)
when 'staging'
  ENV['RAILS_ENV'].colorize(:yellow).underline
when 'production'
  ENV['RAILS_ENV'].colorize(:red).underline
else
  'development'.colorize(:light_blue)
end

Pry.config.prompt_name = "#{app_name} [#{environment_name}] "

require 'hirb'

Hirb.enable

old_print = Pry.config.print
Pry.config.print = proc do |*args|
  Hirb::View.view_or_page_output(args[1]) || old_print.call(*args)
end
