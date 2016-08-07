#!/usr/bin/env ruby
require 'fileutils'
include FileUtils
require 'open3'

def sh(*args)
  output_buffer = ""
  error_buffer = ""
  res = Open3.popen3(*args) do |input, output, error, wait_thr|
    set = [output, error]
    while set.any?
      o = select(set)
      o[0].each do |io|
        begin
          data = io.read_nonblock(64)
          if data && !data.empty?
            output_buffer << data
            error_buffer << data if io == error
          else
            io.close
            set.delete(io)
          end
        rescue EOFError
          io.close
          set.delete(io)
        end
      end
      [output_buffer, error_buffer].each do |buf|
        buf.gsub!(/^.*\n/) do |m|
          printf "%8s %s", Thread.current[:id], m
          ''
        end
      end
    end
    print output_buffer
    print error_buffer
    result = wait_thr.value
    raise "Command failed" unless result.success?
  end
end

mkdir_p 'anim'


length = 5.0
fps = 10.0
frames = (fps * length).floor

filenames = []


queue = Queue.new
workers = Array.new(16) { |i| Thread.new(i) { |n|
                            Thread.current[:id] = n
                        while job = queue.pop
                          sh *job
                        end
                      } }

frames.times do |i|
  t = i / frames.to_f
  filename = "anim/img%04d.png" % i
  queue.push ['openscad', "-D$t=#{t}", '-o', filename, 'box.scad']
  filenames << filename
end

workers.size.times { queue.push(nil) }
workers.each { |w| w.join }

sh 'convert', *filenames, '-delay', (1000 / fps).floor.to_s, '-layers', 'optimize', 'anim.gif'
# sh *%w{ convert anim.gif ( -clone 0--1 -background none +append -quantize transparent  -colors 63  -unique-colors -write mpr:cmap    +delete ) -map mpr:cmap      anim_cmap.gif }
