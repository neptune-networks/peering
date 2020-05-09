require 'yaml'
require 'json'
require 'erb'
require 'fileutils'
require_relative 'helpers'
require_relative 'configuration'

CURRENT_DIRECTORY = File.dirname(__dir__)

def render(file_name, helper)
  path  = "#{CURRENT_DIRECTORY}/templates/#{file_name}"
  file  = File.read(path).chomp
  erb   = ERB.new(file, nil, '<>-')

  erb.result(helper.instance_eval { binding })
rescue Errno::ENOENT
  nil
end
