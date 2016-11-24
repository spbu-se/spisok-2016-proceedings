#!/usr/bin/env ruby

# nothing here

class Section
  def makepdf(start_page)
sec_overlay_template = <<-SEC_OVERLAY_TEMPLATE
\documentclass[10pt,a5paper]{article}

\usepackage{mathspec}
\usepackage{fontspec}
\defaultfontfeatures{Mapping=tex-text,Ligatures={TeX},Kerning=On}

\def\MyTimesFont#1{\expandafter#1[]{Times New Roman}}
\def\MyCourierFont#1{\expandafter#1[]{Courier New}}
\def\MyArialFont#1{\expandafter#1{Arial}}

\MyTimesFont{\setmainfont}
\MyTimesFont{\setromanfont}
\MyTimesFont{\newfontfamily{\cyrillicfont}}
\MyCourierFont{\setmonofont}
\MyCourierFont{\newfontfamily{\cyrillicfonttt}}
\MyArialFont{\setsansfont}
\MyArialFont{\newfontfamily{\cyrillicfontsf}}

\usepackage{polyglossia}
\setdefaultlanguage{russian}
\setotherlanguages{english}

\usepackage[unicode]{hyperref}
\usepackage{authblk}
\usepackage{booktabs}
\usepackage{indentfirst}
\usepackage{titlesec}
\usepackage{graphicx}
\usepackage[table,xcdraw]{xcolor}
\usepackage{listings}
\usepackage{makecell}

\usepackage[top=23mm,left=17mm,right=17mm,bottom=17mm]{geometry}

\usepackage[font=small,skip=0pt]{caption}

\usepackage{fancyhdr}

\begin{document}

\thispagestyle{empty}
Титул
\mbox{}\newpage

\thispagestyle{empty}\mbox{}\newpage

\thispagestyle{fancy}\fancyhf{}
\lhead{4}\rhead{Share\LaTeX}
\mbox{}\newpage

\thispagestyle{fancy}\fancyhf{}
\lhead{Guides and tutorials}\rhead{5}
\mbox{}\newpage

\end{document}
SEC_OVERLAY_TEMPLATE
  end
end