#!/usr/bin/env ruby
require 'fileutils'

Dir.glob("*.scad") do |scadname|
  next if scadname == "box.scad"
  if scadname =~ /_cut\.scad$/
    svgname = File.basename(scadname, '.scad') + '.svg'
    system "openscad", "--render", "-o", svgname, scadname
  else
    pngname = File.basename(scadname, '.scad') + '.png'
    system "openscad", "-o", pngname, scadname
  end
end
