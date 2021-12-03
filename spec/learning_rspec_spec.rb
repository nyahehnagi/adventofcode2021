
require "learning_rspec.rb"

 RSpec.describe HelloWorld do 
    describe '#say hello world' do 
       it "should say 'Hello World' when we call the say_hello method" do 
          hw = HelloWorld.new 
          message = hw.say_hello 
          expect(message).to eq "Hello World!"
       end
    end
 end
