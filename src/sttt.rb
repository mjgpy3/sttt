#!/usr/bin/env ruby

# ARGV[0] = template matcher regex
# ARGV[1..-1] additional args to pass to template

$config = {
  template_dir: '~/.templates',
  default_fill_me_in: 'Xx'
}

require 'erb'

template_names = -> { `find #{$config[:template_dir]} -name *.sttt`.split("\n") }
matcher = -> { Regexp.compile(ARGV[0]) }
matching_template = -> { template_names.().select { |n| n.match(matcher.()) }.first }

class Object
  def or_fill_me
    self
  end
end

class NilClass
  def or_fill_me
    $config[:default_fill_me_in]
  end
end

a = ARGV
fill_me = $config[:default_fill_me_in]

def named(name)
  ARGV.
    select { |a| a.start_with?("#{name}=") }.
    first.
    split('=').
    last
end

renderer = ERB.new(File.open(matching_template.(), 'r', &:read))
print renderer.result(binding)
