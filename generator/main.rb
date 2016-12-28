#!/usr/bin/env ruby

require './metadata.rb'
require './generator.rb'
require './toc.rb'
require './whole.rb'

confname = "{\\addfontfeature{LetterSpace=-3.5}Материалы 6-й всероссийской научной конференции по проблемам информатики СПИСОК-2016}"

sections = load_all_sections(confname)

cpage = 5

sections.each do |s|
  cpage = s.maketex(cpage)
end

gen_toc(sections, "Содержание", confname, cpage)

gen_whole(sections)
