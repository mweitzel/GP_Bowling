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
	
	it "can add a few scores together" do
		answer = "pop pop pop add add"
		parameters = [1, 2, 3]
		@interpreter = Bowling::Interpreter.new(@dsl, answer, parameters)
		@interpreter.run_answer.should == 6
	end

	it "will return a score and a strike added" do
		answer = "pop pop add"
		parameters = [5,'X']
		@interpreter = Bowling::Interpreter.new(@dsl, answer, parameters)
		@interpreter.run_answer.should == 15
	end
	
	it "can score an actual series in bowling based off of parameters" do
		answer = "eject eject peek_front peek_front add add"
		
		parameters = [5, '/', 3]
		@interpreter = Bowling::Interpreter.new(@dsl, answer, parameters)
		@interpreter.run_answer.should == 16

		parameters = [8, '/', 4]
		@interpreter = Bowling::Interpreter.new(@dsl, answer, parameters)
		@interpreter.run_answer.should == 18
	end
	
	it "can give genomal and phenomal metrics" do
		pending

		@interpreter = Bowling::Interpreter.new(@dsl, "", [])
		@interpreter.run_answer.should == 0

		@evaluator.answer_length
		@evaluator.answer_diversity

		#also something about the standard deviation of these
		@evaluator.solution_rightness
		@evaluator.residual_stack_size
	end
end
