#!/usr/bin/env ruby

require './metadata.rb'
require './generator.rb'
require './toc.rb'
require './whole.rb'

sections = load_all_sections("6-я всероссийская научная конференция по проблемам информатики СПИСОК-2016")

cpage = 5

sections.each do |s|
  cpage = s.maketex(cpage)
end

gen_toc(sections, "Содержание")

gen_whole(sections)
