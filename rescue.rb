#!/usr/bin/env ruby

require 'rmagick'
require 'wavefile'
include WaveFile

i = Magick::Image.read('input.bmp').first
center_x = 995
center_y = 1007
turns = 40
speed = 120
duration = 40/120.0*60
a = 1472-center_x
b = 11.8/(Math::PI*2)
x = 0
y = 0
index = 1
pixels = []
while x < 1938-center_x && y < 1007 do
  w = index*(Math::PI/(2048))
  r = a + b*w
  x = (r * Math.cos(w)).round
  y = (r * Math.sin(w)).round
  pixel = i.pixel_color(x+center_x, y+center_y)
  pixels << [pixel.red/257.0/255.0, pixel.green/257.0/255.0, pixel.blue/257.0/255.0].max
  i.pixel_color(x+center_x, y+center_y, 'red')
  index += 1
end
frequency = (pixels.size/duration/1000).round*1000
buffer = Buffer.new(pixels.reverse.each { |p| p }, Format.new(:mono, :float, frequency))
Writer.new("output.wav", Format.new(:mono, :pcm_8, frequency)) do |writer|
  writer.write(buffer)
end

i.write('res.bmp')
