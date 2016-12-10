#!/usr/bin/env ruby

class Section
  def maketex(start_page)
    @start_page = start_page
    emptypage = "\\mbox{}\\newpage"

    chairman_texs = @heads.map do |h|
      <<~HEAD_TEMPLATE
      \\vspace{5mm}
      \\includegraphics[height=5cm]{../../portraits/#{h.photo}}\\\\
      \\vspace{2mm}
      {\\Large \\textbf{\\textsf{#{h.name}}}}\\\\
      \\textsf{#{h.title}}

      HEAD_TEMPLATE
    end

    titletex = <<~TT_OERLAY_TEMPLATE
      \\begin{center}
      \\pdfbookmark[1]{#{@name}}{abspage-#{start_page}}

      {\\huge \\textbf{\\textsf{#{@name}}}}

      #{chairman_texs.join "\n\n\\vspace{5mm}"}
      \\end{center}
      \\newpage
      TT_OERLAY_TEMPLATE

    warning = if @status == true then '' else "{\\Huge \\color{red}~#{@status}}\n" end

    cur_page = start_page + 2

    articles_tex = @articles.map do |a|
      a.start_page = cur_page
      ocp = cur_page
      cur_page += 1
      "\\renewcommand{\\headrulewidth}{0pt}\\newgeometry{margin=15mm,top=25mm}\\resetHeadWidth" +
      if ocp.odd? then
        %(\\thispagestyle{fancy}\\fancyhf{}\\lhead{}\\rhead{#{ocp}})
      else
        %(\\thispagestyle{fancy}\\fancyhf{}\\lhead{#{ocp}}\\rhead{})
      end +
      "\\pdfbookmark[2]{#{a.title}}{abspage-#{ocp}}\n" +
      "\\mbox{}\\newpage\\renewcommand{\\headrulewidth}{0.4pt}\\restoregeometry\\resetHeadWidth\n" +
      (2..a.pagescount).map do |p|
        ocp = cur_page
        cur_page += 1
        if ocp.odd? then
          %(\\thispagestyle{fancy}\\fancyhf{}\\lhead{#{@name}}\\rhead{~~#{ocp}})
        else
          %(\\thispagestyle{fancy}\\fancyhf{}\\lhead{#{ocp}~~}\\rhead{#{a.title}})
        end + '\mbox{}\newpage'
      end.join("\n")
    end.join("\n\n")

    add_empty = cur_page.even?

    finalemptypage = if add_empty then # last is odd
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
      \\usepackage{fancyhdr}

      \\makeatletter
      \\newcommand{\\resetHeadWidth}{\\fancy@setoffs}
      \\makeatother

      
      \\pagestyle{empty}
      \\begin{document}
      #{titletex}

      #{warning}
      
      #{emptypage}
      
      #{articles_tex}
      
      #{finalemptypage}     
      \\end{document}
      SEC_TEMPLATE

      File::open(File::join(@folder, "_section-overlay.tex"), "w:UTF-8") do |f|
        f.write section_tex 
      end

      File::open(File::join(@folder, "_section-compile.sh"), "w:UTF-8") do |f|
        pdfs = ['../../generator/a5-empty.pdf'] * 2 +
          @articles.map { |a| File::basename(a.fullfile) } +
          if add_empty then ['../../generator/a5-empty.pdf'] else [] end
        f.write <<~COMPILE
          #!/bin/sh
          xelatex _section-overlay.tex
          xelatex _section-overlay.tex

          pdftk #{pdfs.join ' '} cat output _section-articles.pdf
          pdftk _section-overlay.pdf multibackground _section-articles.pdf output #{@pdfname}

          mv #{@pdfname} ..

          COMPILE
      end

      cur_page
  end
end
      
      