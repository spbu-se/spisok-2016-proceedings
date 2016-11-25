#!/usr/bin/env ruby

# nothing here

class Section
  def maketex(start_page)

    emptypage = "\\thispagestyle{empty}\\mbox{}\\newpage"

    chairman_texs = @heads.map do |h|
      <<~HEAD_TEMPLATE
      \\vspace{5mm}
      \\includegraphics[height=5cm]{../../portraits/#{h.photo}}\\\\
      \\vspace{5mm}
      {\\Large \\textbf{\\textsf{#{h.name}}}}\\\\
      \\textsf{#{h.title}}

      HEAD_TEMPLATE
    end

    titletex = <<~TT_OERLAY_TEMPLATE
      \\begin{center}
      {\\huge \\textbf{\\textsf{#{@name}}}}

      #{chairman_texs.join "\n\n\\vspace{5mm}"}
      \\end{center}
      TT_OERLAY_TEMPLATE

    page_pairs = <<~PP_TEMPLATE
      \\thispagestyle{fancy}\\fancyhf{}
      \\lhead{4}\\rhead{Share\\LaTeX}
      \\mbox{}\\newpage

      \\thispagestyle{fancy}\\fancyhf{}
      \\lhead{Guides and tutorials}\\rhead{5}
      \\mbox{}\\newpage
      PP_TEMPLATE

    cur_page = start_page + 2

    articles_tex = @articles.map do |a|
      a.start_page = cur_page
      cur_page += 1
      %(
        \\thispagestyle{empty}
        \\noindent\\begin{picture}(148,210)
        \\put(-17,23){\\hbox{\\includegraphics[width=148mm,page=1]{#{a.fullfile}}}}
        \\end{picture}
        \\newpage
      ) +
      (2..a.pagescount).map do |p|
        ocp = cur_page
        cur_page += 1
        if ocp.odd?
          %(\\thispagestyle{fancy}\\fancyhf{}\\lhead{#{@name}}\\rhead{#{ocp}})
        else
          %(\\thispagestyle{fancy}\\fancyhf{}\\lhead{#{ocp}}\\rhead{#{a.title}})
        end +
        %(
          \\noindent\\begin{picture}(148,210)
          \\put(-17,28){\\hbox{\\includegraphics[width=148mm,page=#{p}]{#{a.fullfile}}}}
          \\end{picture}
          \\newpage
        )        
      end.join("\n")
    end.join("\n\n")

    finalemptypage = if cur_page.even? then # last is odd
      cur_page += 1
      emptypage
    else
      ''
    end

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
      \\usepackage{graphicx}
      \\usepackage[table,xcdraw]{xcolor}
      \\usepackage{listings}
      \\usepackage{makecell}
      
      \\usepackage[top=23mm,left=17mm,right=17mm,bottom=17mm]{geometry}     
      \\usepackage[font=small,skip=0pt]{caption}
      \\usepackage[pages=some,opacity=1,position={0,0}]{background}     
      \\usepackage{fancyhdr}
      
      \\setlength{\\unitlength}{1mm}
      \\begin{document}

      \\newcommand\\backimage[2]{\\BgThispage{}\\backgroundsetup{contents={\\includegraphics[#1]{#2}}}}
      
      \\thispagestyle{empty}
      #{titletex}
      \\mbox{}\\newpage
      
      #{emptypage}
      
      #{articles_tex}
      
      #{finalemptypage}
      
      \\end{document}
      SEC_TEMPLATE

      File::open(File::join(@folder, "section.tex"), "w:UTF-8") do |f| 
        f.write section_tex 
      end 

      cur_page
  end
end
      
      