# frozen_string_literal: true

require 'adassault/version'
require 'adassault/cli/dns'

require 'gli'
require 'paint'

module ADAssault
  # Class containing all commands and sub-commands for the CLI,
  # mapping CLI commands with library classes.
  # @since 0.0.1
  class CLI
    extend GLI::App

    program_desc 'ADAsault desc'
    subcommand_option_handling :normal
    sort_help :alpha # :manually
    version ADAssault::VERSION

    switch [:color], desc: 'Switch colorized output', default_value: true
    switch [:debug], desc: 'Display options', default_value: false
    pre do |global_options, command, options, args|
      Paint.mode = 0 unless global_options[:color]
      if global_options[:debug]
        puts 'Global options:'
        p global_options
        puts "\nCommand:"
        p command
        puts "\nLocal options:"
        p options
        puts "\nArguments:"
        p args
      end
      true # https://github.com/davetron5000/gli/issues/321
    end
  end
end
