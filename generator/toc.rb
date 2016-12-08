#!/usr/bin/env ruby

def gen_toc(sections, toctitle)
  draft_page_numbers_warned = false
  toc = sections.map do |s|
    if s.status == true or draft_page_numbers_warned then '' else
      draft_page_numbers_warned = true
      "\\noindent{\\color{red}~Внимание! Номера страниц ниже могут измениться.}\n\n"
    end +
    "\\contentsline{section}{#{s.name}}{#{s.start_page}}{}\n" +
    if s.status == true then '' else "{\\color{red}~#{s.status}}\n" end +
    s.articles.map do |a|
      "\\contentsline{subsection}{#{a.by}#{if not a.by.end_with?('.') then '.' else '' end}~#{a.title}}{#{a.start_page}}{}"
    end.join("\n")
  end.join("\n\n")

  section_tex = <<~SEC_TEMPLATE
    \\documentclass[10pt,a5paper]{article}

    \\usepackage{mathspec}
    \\usepackage{fontspec}
    \\defaultfontfeatures{Mapping=tex-text,Ligatures={TeX},Kerning=On}

    \\def\\MyTimesFont#1{\\expandafter#1[]{Times New Roman}}
    \\def\\MyCourierFont#1{\\expandafter#1[]{Courier New}}
    \\def\\MyArialFont#1{\\expandafter#1{Arial}}

    \\MyTimesFont{\\setmainfont}
    \\MyTimesFont{\\setromanfont}
    \\MyTimesFont{\\newfontfamily{\\cyrillicfont}}
    \\MyCourierFont{\\setmonofont}
    \\MyCourierFont{\\newfontfamily{\\cyrillicfonttt}}
    \\MyArialFont{\\setsansfont}
    \\MyArialFont{\\newfontfamily{\\cyrillicfontsf}}

    \\usepackage{polyglossia}
    \\setdefaultlanguage{russian}
    \\setotherlanguages{english}

    \\usepackage[unicode]{hyperref}
    \\usepackage{authblk}
    \\usepackage{booktabs}
    \\usepackage{indentfirst}
    \\usepackage{titlesec}
    \\usepackage[table,xcdraw]{xcolor}

    \\usepackage[top=17mm,left=17mm,right=17mm,bottom=17mm]{geometry}
    \\usepackage[font=small,skip=0pt]{caption}
    \\usepackage{fancyhdr}

    \\usepackage{tocloft}
    \\setlength{\\cftsecnumwidth}{0pt}
    \\setlength{\\cftsubsecnumwidth}{0pt}


    \\pagestyle{empty}
    \\begin{document}
    \\begin{center}
    {\\Large \\textbf{#{toctitle}}}
    \\end{center}

    #{toc}
    \\end{document}
    SEC_TEMPLATE

    File::open(File::join("..", "sections", "_toc.tex"), "w:UTF-8") do |f|
      f.write section_tex
    end
end