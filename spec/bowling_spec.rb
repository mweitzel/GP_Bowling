
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

		it "returns proc when asked for referencing each primitive by its token" do
			@dsl.primatives.keys.each do |key|
				@dsl.proc_from(key).instance_of?(Proc).should be_true
			end
		end

		it "proc from numbers return number when called" do
			for i in -1..9 do
				@dsl.proc_from(i.to_s).call.should == i.to_s
			end
		end

		it "stuff does shit you expect" do
			['/', 'X'].each do |i|
				@dsl.proc_from(i.to_s).call.should == i
			end
		end
		
		it "'if' returns false for 0 and negative 1 ...and true for everthing else" do
			@dsl.proc_from('if').call("-1").should == false
			@dsl.proc_from('if').call("0").should == false
			@dsl.proc_from('if').call("1").should == true 
			@dsl.proc_from('if').call("X").should == true 
			@dsl.proc_from('if').call("/").should == true 
			@dsl.proc_from('if').call("9").should == true 
		end
		
		it "'if_eq' compares string value of each parameter" do
			if_eq = @dsl.proc_from('if_eq')
			if_eq.call('X', 'X').should == true
			if_eq.call('X', "/").should == false
			if_eq.call('/', "/").should == true
			if_eq.call('X', "10").should == false
			if_eq.call('3', "10").should == false
			if_eq.call('3', "3").should == true
		end

		it "" do
			
		end
	
	end

	context "Interpreter" do
		
		it "can be instanciated with dsl and answer" do

			my_dsl = "I am a stub for an object"

			@interpreter = Bowling::Interpreter.new(my_dsl, "X / peek_front 4")
			@interpreter.var_stack.should == []
			@interpreter.dsl.should == my_dsl
			@interpreter.answer.length.should == 4
			
		end


		it "executes answer from left to right" do
			
			@dsl = mock(Bowling::DSL)
			@interpreter = Bowling::Interpreter.new(@dsl, "3 4 5")
			@dsl.stub(:proc_from).with('3').and_return(Proc.new { 'a result!'} )
			
			@interpreter.execute_next

			@interpreter.answer.should == ['4', '5']

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

		it "will consume parameters to fulfill parameter requiring proc if available" do	
			@dsl = mock(Bowling::DSL)
			@dsl.stub(:proc_from).with('2').and_return(Proc.new {'two'} )
			@dsl.stub(:proc_from).with('3').and_return(Proc.new {'three'} )
			@dsl.stub(:proc_from).with('4').and_return(Proc.new {'four'} )
			@dsl.stub(:proc_from).with('5').and_return(Proc.new { |param1, param2|
																														 param1 + " plus " + param2
																														}
																									)

			@interpreter = Bowling::Interpreter.new(@dsl, "2 3 4 5 6")
			
			@interpreter.execute_next
			@interpreter.var_stack.should == ['two']

			@interpreter.execute_next
			@interpreter.var_stack.should == ['two', 'three']
			
			@interpreter.execute_next
			@interpreter.var_stack.should == ['two', 'three', 'four']
			
			@interpreter.execute_next
			@interpreter.answer.should == ['6']
			@interpreter.var_stack.should == ['two', 'three plus four']

		end

		it "will run whole answer if asked to" do
			@dsl = mock(Bowling::DSL)
			@dsl.stub(:proc_from).with('2').and_return(Proc.new {'two'} )
			@dsl.stub(:proc_from).with('3').and_return(Proc.new {'three'} )
			@dsl.stub(:proc_from).with('4').and_return(Proc.new {'four'} )
			@dsl.stub(:proc_from).with('5').and_return(Proc.new { |param1, param2|
																														 param1 + " plus " + param2
																														}
																									)
			
			@interpreter = Bowling::Interpreter.new(@dsl, "2 3 4 5 5")
			@interpreter.run_answer
			@interpreter.answer.should == []
			@interpreter.var_stack.should == ['two plus three plus four']
		end

		it "does not add return value of the Proc's call if it is nil" do
			@dsl = mock(Bowling::DSL)
			@dsl.stub(:proc_from).with('2').and_return(Proc.new {'two'} )
			@dsl.stub(:proc_from).with('gimme_nil').and_return(Proc.new {nil})

			@interpreter = Bowling::Interpreter.new(@dsl, "2 gimme_nil 2")
			@interpreter.run_answer
			@interpreter.answer.should == []
			@interpreter.var_stack.should == ['two', 'two']
		end

	end

	context "Creator" do

	end

	context "Evaluator" do

	end

	context "Picker" do

	end

end
