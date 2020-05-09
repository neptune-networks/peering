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

Dir.chdir(CURRENT_DIRECTORY) do
  Dir.glob("config/*.yml").each do |config_file|
    Dir.glob("templates/{[!_]*}.erb").each do |template_file|
      new_filename = template_file.split('/').last.gsub('.erb', '')

      out_directory_name = config_file.split('/').last.gsub('.yml', '')
      out_directory_path = "#{File.dirname(__dir__)}/out/#{out_directory_name}/"
      FileUtils.mkdir_p(out_directory_path)

      configuration = Configuration.from_yaml(config_file)
      helper = Helpers::Peers.new(configuration)
      computed_template = render(template_file.split('/').last, helper)

      File.write("#{out_directory_path}/#{new_filename}", computed_template)
    end
  end
end
