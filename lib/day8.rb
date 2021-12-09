$LOAD_PATH << './lib'
require 'file_management.rb'
require 'benchmark'

include FileManagement

signal_data =  getData("data/inputday8.txt").map {|line| line.split(" | ")}

#get data for part 1
signal_output_data = signal_data.map{|output_line| output_line[1]}

unique_count = [2,3,4,7]
# look for codes which are of the unique lengths of 2,3,4 and 7 and count then sum them up 
puts signal_output_data.map{ |line| line.split.map{|word| word.length}.select{|el| unique_count.include?(el)}.count}.sum


# PART 2
def find_chars(subject, characters)
    characters.chars.all? { |char| subject.include?(char) }
end
sum = 0
# Get the unique codes 
signal_data.each do |line|
    # Hash to store the 7 segments of a digit
    seven_segment_display = Array.new(7, "")

    # get the unique codes which represent 0-9
    digits =  line.map{|line| line.split(" ")}.flatten.map{|segment_code| segment_code.chars.sort.join}.uniq

    p digits
    ### NUMBERS WE KNOW ALREADY - 1,4,7 and 8
    number_one = digits.select{|digit| digit.size == 2}[0]
    number_seven = digits.select{|digit| digit.size == 3}[0]
    number_four = digits.select{|digit| digit.size == 4}[0]
    number_eight = digits.select{|digit| digit.size == 7}[0]

    ##################### SEGMENT 1 #######################
    # Work out segment (1) from numbers 1 and 7
    seven_segment_display[0] = number_seven.gsub(Regexp.new("[#{number_one}]") , "")

    ###################### SEGMENT 3 and 6 #################
    # Work out segments for the 6 digit codes
    six_digits =  digits.select{|digit| digit.size == 6}
    # Work out segment 5 and thus No 6 by removing the 2 digits which have No 1 in it
    number_six =  six_digits.reject {|digit| find_chars(digit, number_one)}[0]
    # Segment 3 is the missing letter in number 6
    seven_segment_display[2] = number_eight.gsub(Regexp.new("[#{number_six}]") , "")
    # set segment 6
    seven_segment_display[5] = number_one.gsub(Regexp.new("[#{seven_segment_display[2]}]") , "")

    ###################### SEGMENT 7 and 4 #######################
    five_digits = digits.select{|digit| digit.size == 5}
    # isolate the number 3 - it must contain the segments (1,3 and 6) we have already found
    number_three =  five_digits.select {|digit| find_chars(digit, seven_segment_display.join)}[0]

    tmp =  number_three.gsub(Regexp.new("[#{number_four}]") , "")
    seven_segment_display[6] = tmp.gsub(Regexp.new("[#{seven_segment_display[0]}]") , "")
    # Now we can find out segment 4
    seven_segment_display[3] = number_three.gsub(Regexp.new("[#{seven_segment_display.join}]") , "")

    ###################### SEGMENT 1 #######################
    # we know all the other parts of number 4 bar one
    seven_segment_display[1] = number_four.gsub(Regexp.new("[#{seven_segment_display.join}]") , "")

    ###################### SEGMENT 5 #######################
    # segment 5 can be derived from the number 8
    seven_segment_display[4] = number_eight.gsub(Regexp.new("[#{seven_segment_display.join}]") , "")

    number_zero = (seven_segment_display[0] + seven_segment_display[1] +  seven_segment_display[2]+  seven_segment_display[4] +  seven_segment_display[5] + seven_segment_display[6]).chars.sort.join
    number_two = (seven_segment_display[0] +  seven_segment_display[2] + seven_segment_display[3] + seven_segment_display[4] + seven_segment_display[6]).chars.sort.join
    number_five = (seven_segment_display[0] +  seven_segment_display[1]  + seven_segment_display[3]  + seven_segment_display[5]  + seven_segment_display[6]).chars.sort.join
    number_nine = (seven_segment_display[0]  + seven_segment_display[1]  + seven_segment_display[2]  + seven_segment_display[3] + seven_segment_display[5]  + seven_segment_display[6]).chars.sort.join

    p seven_segment_display

    output =  line[1].split(" ").map{|output_code| output_code.chars.sort.join}
    p output
    output_number = ""
    output.each do |code|
        case code
        when number_zero 
            output_number += "0" 
        when number_one
            output_number += "1" 
        when number_two
            output_number += "2" 
        when number_three
            output_number += "3" 
        when number_four
            output_number += "4" 
        when number_five
            output_number += "5" 
        when number_six
            output_number += "6" 
        when number_seven
            output_number += "7" 
        when number_eight
            output_number += "8" 
        when number_nine
            output_number += "9" 
        else
            p "OH SHIT #{code}"
            # do nothing we have a problem 
        end
    end

    sum += output_number.to_i
end
 p sum
=begin

   0:      1:      2:      3:      4:
 aaaa    ....    aaaa    aaaa    ....
b    c  .    c  .    c  .    c  b    c
b    c  .    c  .    c  .    c  b    c
 ....    ....    dddd    dddd    dddd
e    f  .    f  e    .  .    f  .    f
e    f  .    f  e    .  .    f  .    f
 gggg    ....    gggg    gggg    ....

  5:      6:      7:      8:      9:
 aaaa    aaaa    aaaa    aaaa    aaaa
b    .  b    .  .    c  b    c  b    c
b    .  b    .  .    c  b    c  b    c
 dddd    dddd    ....    dddd    dddd
.    f  e    f  .    f  e    f  .    f
.    f  e    f  .    f  e    f  .    f
 gggg    gggg    ....    gggg    gggg

=end