#!/usr/bin/env ruby

require './metadata.rb'
require './generator.rb'
require './toc.rb'
require './whole.rb'

sections = load_all_sections

cpage = 5

sections.each do |s|
  cpage = s.maketex(cpage)
end

gen_toc(sections, "Содержание")

gen_whole(sections)
