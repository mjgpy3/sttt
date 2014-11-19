#!/usr/bin/env ruby

# ARGV[0] = template matcher regex

require 'erb'

$config = {
  template_dir: '~/.templates'
}

template_names = -> { `find #{$config[:template_dir]} -name *.sttt`.split("\n") }
matcher = -> { Regexp.compile(ARGV[0]) }
matching_template = -> { template_names.().select { |n| n.match(matcher.()) }.first }

a = ARGV

renderer = ERB.new(File.open(matching_template.(), 'r', &:read))
puts renderer.result(binding)
