#!/usr/bin/env ruby

def gen_whole(sections)
  File::open(File::join("..", "sections", "_gen_whole.sh"), "w:UTF-8") do |f|
    f.puts "#!/bin/sh\n"
    sections.each do |s|
      f.puts <<~SPP
        pushd #{s.folder}
        . _section-compile.sh
        popd
        SPP
    end

    f.puts <<~TOC
      xelatex _toc.tex
      xelatex _toc.tex

      pdftk _a_begin.pdf #{sections.map {|s| s.pdfname}.join(' ')} _toc.pdf _z_end.pdf cat output spisok.pdf
      TOC
  end
end
