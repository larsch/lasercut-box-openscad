#!/usr/bin/env ruby
require 'fileutils'

Dir.glob("*.scad") do |scadname|
  next if scadname == "box.scad"
  pngname = File.basename(scadname, '.scad') + '.png'
  system "openscad", "-o", pngname, scadname
end
