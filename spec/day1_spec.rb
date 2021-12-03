# to run the test use the below command in the terminal
# rspec spec/day1_spec.rb

require "day1.rb"

depth_test_data = [199,200,208,210,200,207,240,269,260,263]

describe 'How many measurements are larger than the previous measurement?' do 
    it "should say 7 when we use the test data  provided" do 
        count = count_increases(depth_test_data)
        expect(count).to eq 7
    end
end

describe 'How many measurements are larger than the previous measurement when using a sliding window of 3?' do 
    it "should say 5 when we use the test data provided" do 
        count = count_increase_three_measurement_window(depth_test_data)
        expect(count).to eq 5
    end
end

