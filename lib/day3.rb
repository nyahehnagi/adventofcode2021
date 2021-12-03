$LOAD_PATH << './lib'
require 'file_management.rb'
require 'class_submarine.rb'
require 'benchmark'

include FileManagement

diagnostic_report =  getData("data/inputday3.txt")

split_bits = []
bit_hash = Hash.new()

puts Benchmark.realtime{
    #split each binary number into individual bits 
    diagnostic_report.map do |lines|
            split_bits << lines.split('')
    end

    #transpose the bits
    split_bits.each do |element|
        element.each_with_index do |bit, index|
            bit_hash.key?(index)  ? bit_hash[index] << bit : bit_hash[index] = bit
        end
    end

    #part 1
    #find gamma rate
    gamma_rate_binary = ""
    bit_hash.each_value do |bits|
        bits.count('1') > bits.count('0') ? gamma_rate_binary.concat("1") : gamma_rate_binary.concat("0")
    end

    gamma_rate_decimal = gamma_rate_binary.to_i(2)

    #find epsilon rate - flip the bits using XOR
    bit_mask = "1" * gamma_rate_binary.length 
    epsilon_rate_decimal =  gamma_rate_decimal ^ bit_mask.to_i(2)

    #output part 1 answer
    puts epsilon_rate_decimal * gamma_rate_decimal
}

#part 2
puts Benchmark.realtime{
    #create copy of bit_hash to work on
    def deep_copy(obj)
        Marshal.load(Marshal.dump(obj))
    end

    bit_hash_oxygen = deep_copy(bit_hash)
    bit_hash_co2  = deep_copy(bit_hash)

    #remove characters at specified indices
    def remove_chars(str, indices)      
        indices.sort.reverse_each { |i| str[i] = '' }
        str
    end

    # from the passed bit string the bit to be deleted is deleted along with it's corresponding position bits in the passed hash  
    def remove_bits (hash_of_bit_strings, bit_string, bit_to_delete)
        indexes_to_delete = []
        # from the passed string of bits, work out which indices will be deleted based on value of passed bit
        bit_string.each_char.with_index do |bit, index|
            if bit == bit_to_delete
                indexes_to_delete << index
            end 
        end

        #delete the bits at specified index in the passed hash (terrible idea changing the contents of an object by reference to be used outside of the function)
        hash_of_bit_strings.each_value do |bits|
            bits = remove_chars(bits,indexes_to_delete)
        end

    end

    bit_hash_oxygen.each_value do |bits|
        # if we have one value left in our hash.. we have our value
        break if bit_hash_oxygen[0].length == 1
        
        if bits.count('1') >= bits.count('0') 
            # keep the ones
            remove_bits(bit_hash_oxygen,bits,"0")
        else
            #keep the zeroes
            remove_bits(bit_hash_oxygen,bits,"1")
        end
        
    end

    bit_hash_co2.each_value do |bits|
        # if we have one value left in our hash.. we have our value
        break if bit_hash_co2[0].length == 1
        
        if bits.count('1') == bits.count('0') 
            # keep the zeroes
            remove_bits(bit_hash_co2,bits,"1")
        elsif bits.count('1') < bits.count('0') 
            # keep the ones
            remove_bits(bit_hash_co2,bits,"0")
        else
            #keep the zeroes
            remove_bits(bit_hash_co2,bits,"1")
        end
    end


    #convert to string and decimalise
    oxygen_string = ""
    co2_string = ""
    bit_hash_oxygen.each_value{|v| oxygen_string += v}
    bit_hash_co2.each_value{|v| co2_string += v}

    puts oxygen_string.to_i(2) * co2_string.to_i(2)
}


