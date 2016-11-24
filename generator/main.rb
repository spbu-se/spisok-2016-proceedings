#!/usr/bin/env ruby

require './metadata.rb'
require './generator.rb'

sections = load_all_sections

sections.each &method(:p)
