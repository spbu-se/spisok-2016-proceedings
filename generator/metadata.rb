#!/usr/bin/env ruby

require 'yaml'

class Article
end

class Section
  def initialize(folder)
    secdic = YAML::load_file(File.join(folder, 'section.yml'))
  end
end


def load_all_sections
  sectionfolders = Dir.glob(File.join(File.dirname(File.expand_path(__FILE__)), "../sections/*")).select(&File::method(:directory?))
  sections = sectionfolders.map do |f|
    Section.new f
  end
end
