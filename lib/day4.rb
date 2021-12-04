
$LOAD_PATH << './lib'
require 'file_management.rb'
require 'benchmark'
require 'securerandom'

include FileManagement

bingo_data =  getData("data/inputday4.txt")


class BingoCard

    attr_accessor :card_marked_won, :winning_number

    def initialize (bingo_card_numbers)
        @uuid = SecureRandom.uuid
        @card_marked_won = false
        @winning_number = -1
        @bingo_card_rows = []
        generate_bingo_card(bingo_card_numbers)
    end

    def play_number (number)
        #TODOneed to optimise
        winning_number = false
        @bingo_card_rows.each do |row|
            row.each do |bingo_number|
                if bingo_number.number == number
                    bingo_number.matched = true
                    winning_number = is_winning_number()
                end
            end
        end

        score = 0
        if winning_number == true
            @card_marked_won = true
            @winning_number = number
            score = calculate_score() 
        end
        return score
    end
 

    def is_winning_number ()
        #check rows
        @bingo_card_rows.each do |row|
            if row.select { |bingo_number| bingo_number.matched == true }.count == 5
                
                return true
            end
        end

        5.times do |n|
            match_count = 0

            @bingo_card_rows.each do |row|
                if row[n].matched == true
                    match_count += 1
                end
            end
            
            if match_count == 5
                return true
            end
         end 

         return false
    end

    def calculate_score()
        tmp = []
        @bingo_card_rows.each do |row|
            tmp << row.select { |bingo_number| bingo_number.matched == false }
        end

        tmp.flatten!

        sum = 0
        tmp.each do |item|
            puts "This is non matched number from card : #{item.number}"
            sum += item.number.to_i
        end

        puts "Sum of non matched is: #{sum}"
        #return tmp.inject(0){|sum,x| sum + x.number }
        return sum
    end

    def generate_bingo_card(bingo_numbers)
        bingo_numbers.each do |line|
            new_row = []
            tmp_row = line.split
            tmp_row.each {|number| new_row << BingoNumber.new(number)}
            @bingo_card_rows << new_row
        end        
    end
end

class BingoNumber
    attr_reader :number
    attr_accessor :matched

    def initialize (number)
        @number = number
        @matched = false
    end

end

class BingoGame

    def initialize (bingo_data)
        @bingo_game_numbers = [] 
        @bingo_cards = []
        @last_card_to_win
        generate_bingo_numbers(bingo_data)
        generate_bingo_cards(bingo_data)
    end

    def generate_bingo_numbers(bingo_data)
        @bingo_game_numbers =  bingo_data.take(1)[0].split(",") 
    end

    def generate_bingo_cards(bingo_data)
        #strip the first element from the bingo_data array as they are the game numbers and a blank line
        card_data = bingo_data.drop(1)
        until card_data.length == 0 do
            #get the bingo data less the new line
            new_bingo_card = card_data.take(6).drop(1)
            #Create a bingo card
            @bingo_cards << BingoCard.new(new_bingo_card)
            #remove this bingo card data in readiness to process the next card
            card_data = card_data.drop(6)
        end
    end

    def play_game
        number_counter = 0
        winner_found = false
        score = 0
        number = 0

        loop do
            
            puts "playing number: #{@bingo_game_numbers[number_counter]}"
            number = @bingo_game_numbers[number_counter]

            @bingo_cards.each do |card|
                score = card.play_number(number)
                if score > 0
                    puts "WINNNER"
                    winner_found = true
                    break
                end
            end
            number_counter += 1
            break if winner_found == true
        end
        
        puts "Winning number is #{number}"
        puts "Winning score sum is #{score}"
        overall_score = number.to_i * score.to_i
        puts "Overall score is : #{overall_score}"
        
        return overall_score
    end

    def play_game_find_last
        number_counter = 0
        winner_found = false
        score = 0
        number = 0
        cards_that_have_won= []

       @bingo_game_numbers.each do |number|
            
            puts "playing number: #{number}"

            @bingo_cards.each do |card|
                if card.card_marked_won == false
                    score = card.play_number(number)
                    if score > 0
                        cards_that_have_won << card
                    end
                end
            end
        end

        score = cards_that_have_won.last.calculate_score
        puts "The sum of the last one matched is: #{score}"
        puts "The last number matched was #{cards_that_have_won.last.winning_number}"
        puts "The answer is #{cards_that_have_won.last.winning_number.to_i * score.to_i }"
    end


end


bingo_game = BingoGame.new(bingo_data)
#puts bingo_game.play_game
bingo_game.play_game_find_last
