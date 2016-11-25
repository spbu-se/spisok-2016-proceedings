#!/usr/bin/env ruby

require 'yaml'

class Chairman
  attr_reader :name, :photo, :title

  def initialize(chdic, sec)
    @section = sec
    @name = chdic['name']
    @photo = chdic['photo']
    @title = chdic['title']
  end
end

class Article
  attr_reader :section, :title, :by, :file, :fullfile, :articles, :pagescount
  attr_accessor :start_page

  def getpagescount
    output = `pdftk #{@fullfile} dump_data`
    /NumberOfPages:\s+(?<npages>\d+)/ =~ output
    if npages
      npages.to_i
    else
      raise "No number of pages in #{@fullfile}"
      nil
    end
  end
  def initialize(ardic, sec)
    @section = sec
    @title = ardic['title']
    @by = ardic['by']
    @file = ardic['file']
    @fullfile = File::join(sec.folder, @file)
    @pagescount = self.getpagescount
    @start_page = nil
  end
end

class Section
  attr_reader :folder, :name, :ready, :heads, :articles
  attr_accessor :start_page

  def initialize(secdic, folder)
    @folder = folder
    @name = secdic['name']
    @ready = secdic['ready']
    @heads = secdic['heads'].map { |h| Chairman::new(h, self) }
    @articles =
      if secdic.has_key?('articles')
        secdic['articles'].map { |a| Article::new(a, self) }
      else
        []
      end
  end
end

def load_all_sections
  sectionfolders = Dir[File::join(File::dirname(File::expand_path(__FILE__)), "../sections/*")].select(&File::method(:directory?))
  sections = sectionfolders.map do |f|
    Section::new(YAML::load_file(File::join(f, 'section.yml')), f)
  end
end
