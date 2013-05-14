
# interpreter
#   
# creator
#   random
#   shuffle
# evaluator
#   examples
# picker


require 'spec_helper'

describe Bowling do
	
	context "DSL" do

		before(:all) do
			@dsl = Bowling::DSL.new
		end
	
		it "has pieces of a language" do
			@dsl.should_not be_nil
			@dsl.primatives.keys.should include('/')
			@dsl.primatives.keys.should include('1')
		end

	end

	context "Interpreter" do
		
		it "can be instanciated with dsl and answer" do

			my_dsl = "I am a stub for an object"

			@interpreter = Bowling::Interpreter.new(my_dsl, "X / peek_front 4")
			@interpreter.var_stack.should == []
			@interpreter.exec_stack.should == []
			@interpreter.dsl.should == my_dsl
			@interpreter.answer.length.should == 4
			
		end


		it "executes answer from left to right" do
			
			@dsl = mock(Bowling::DSL)
			@interpreter = Bowling::Interpreter.new(@dsl, "3 4 5")
			
			@interpreter.next_to_execute.should == '3'

		end

		it "shifts token from answer when its execution is attempted, result is in var_stack" do
			
			@dsl = mock(Bowling::DSL)
			@dsl.stub(:proc_from).with('3').and_return(Proc.new {'a result!'} )

			@interpreter = Bowling::Interpreter.new(@dsl, "3 4 5")
			
			@interpreter.execute_next
			
			@interpreter.answer.should == ['4', '5']
			@interpreter.var_stack.should == ['a result!']

		end
		
		it "operator is dumped and var_stack is unchanged if there are not enough parameters in it" do
			
			@dsl = mock(Bowling::DSL)
			@dsl.stub(:proc_from).with('3').and_return(Proc.new { |param1, param2| 'a result!'} )

			@interpreter = Bowling::Interpreter.new(@dsl, "3 4 5")
			
			@interpreter.execute_next
			
			@interpreter.answer.should == ['4', '5']
			@interpreter.var_stack.should == []

		end

		
		it "operator is dumped and var_stack is unchanged if there are not enough parameters in it 2" do
			
			@dsl = mock(Bowling::DSL)
			@dsl.stub(:proc_from).with('3').and_return(Proc.new { 'three'} )
			@dsl.stub(:proc_from).with('4').and_return(Proc.new { |param1, param2| 'four'} )

			@interpreter = Bowling::Interpreter.new(@dsl, "3 4 5")
			
			@interpreter.execute_next
			@interpreter.execute_next
			
			@interpreter.answer.should == ['5']
			@interpreter.var_stack.should == ['three']

		end
		it "...blapgh" do	
			@dsl = mock(Bowling::DSL)
			@dsl.stub(:proc_from).with('3').and_return(Proc.new {'three'} )
			@dsl.stub(:proc_from).with('4').and_return(Proc.new {'four'} )
			@dsl.stub(:proc_from).with('5').and_return(Proc.new { |param1, param2|
																															"asdf" + param1.to_s + " .."#+ " plus " + param2
																														}
																									)

			@interpreter = Bowling::Interpreter.new(@dsl, "3 4 5 6")
			
			@interpreter.execute_next
			@interpreter.execute_next
			@interpreter.execute_next
			
			@interpreter.answer.should == ['6']
			@interpreter.var_stack.should == ['three plus four']

		end

	end

	context "Creator" do

	end

	context "Evaluator" do

	end

	context "Picker" do

	end

end
