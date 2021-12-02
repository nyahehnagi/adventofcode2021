$LOAD_PATH << './lib'
require 'file_management.rb'
require 'class_submarine.rb'

include FileManagement

movement_data =  getData("data/inputday2.txt")


submarine = Submarine.new
movement_data.each do |item|
    submarine.move_instruction (item)
end

puts submarine.horizontal_distance * submarine.depth