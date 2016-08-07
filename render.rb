#!/usr/bin/env ruby
require 'fileutils'

Dir.glob("*.scad") do |scadname|
  next if scadname == "box.scad"
  pngname = File.basename(scadname, '.scad') + '.png'
  if scadname =~ /_cut\.scad$/
    svgname = File.basename(scadname, '.scad') + '.svg'
    system "openscad", "--render", "-o", svgname, scadname
    system "convert", svgname, pngname
  else
    system "openscad", "-o", pngname, scadname
  end
end
