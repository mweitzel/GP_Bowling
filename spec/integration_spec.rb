require 'spec_helper'


describe Bowling do
	
	before (:each) do
		@dsl = Bowling::DSL.new
	end

	it "should be able to run and get the right score" do

		answer = "3"
		@interpreter = Bowling::Interpreter.new(@dsl, answer, [])
		@interpreter.run_answer.should == 3
	
		answer = "4"
		@interpreter = Bowling::Interpreter.new(@dsl, answer, [])
		@interpreter.run_answer.should == 4

		answer = ""
		@interpreter = Bowling::Interpreter.new(@dsl, answer, [])
		@interpreter.run_answer.should == 0
	end
	
	
	it "can add stuff like you'd expect" do
		answer = "3 4 add"
		@interpreter = Bowling::Interpreter.new(@dsl, answer, [])
		@interpreter.run_answer.should == 7
	end
	
	it "will nancholantly ignore things that shouldnt have been on the stack in the first place" do
		answer = "3 definitely_not_part_of_language"
		@interpreter = Bowling::Interpreter.new(@dsl, answer, [])
		@interpreter.run_answer.should == 3
	end

end
