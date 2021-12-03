$LOAD_PATH << './lib'
require 'file_management.rb'
require 'class_submarine.rb'

include FileManagement

movement_data =  getData("data/inputday2.txt")


submarine = Submarine.new
movement_data.each do |instruction|
    submarine.move_instruction (instruction)
end

puts submarine.horizontal_distance * submarine.depth