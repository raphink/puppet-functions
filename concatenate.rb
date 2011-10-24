#!/usr/bin/ruby
 
module Puppet::Parser::Functions
  newfunction(:concatenate, :type => :rvalue) do |args|
    directory = args[0]
    # optional argument to add include messages
    # comment = args[1]

    # concatenation directory
    concatenatedir = "/var/lib/puppet/concatenate"

    # initialize content
    content = ""

    Dir[ "#{concatenatedir}/#{directory}/*" ].each do |filepath|
      if filepath =~ /\d\d_\S+/
        # get class name 
        file_class = filepath.sub(/.*\d\d_(\S+)/,'\1')

        # check if class is defined
        #method = Puppet::Parser::Functions.function(:defined)
        #if send(method,file_class)

	#system("grep '^#{file_class}$' /etc/puppet/classes.txt")
	#if $?==0
	
	class_list = classlist()
	puts "List of classes : #{class_list}"
	
	if classlist().include?(file_class)
	
        # include file
	  begin
            file = File.new(filepath, "r")
            while (line = file.gets)
              content << "#{line}"
            end
            file.close
          rescue => err
            raise Puppet::ParseError, err
            err
          end
        else
          puts "I: Class #{file_class} is not defined. Not including #{filepath}"
        end
      else
        puts "W: #{filepath} does not have a correct name and will not be included."
      end
    end
    return content
  end
end
