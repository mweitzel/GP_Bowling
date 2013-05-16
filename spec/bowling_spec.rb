
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
		
		it "'if' returns nil for number less than 0 and passed value for everthing else" do
			my_if = @dsl.proc_from('if')
			my_if.call('-1', 'value').should == nil
			my_if.call("0", 'value' ).should == nil
			my_if.call("1", 'value' ).should == 'value' 
			my_if.call("X", 'value' ).should == 'value'  
			my_if.call("/", 'value' ).should == 'value' 
			my_if.call("9", 'value' ).should == 'value' 
		end
		
		it "'eq' compares string value of each parameter" do
			eq = @dsl.proc_from('eq')
			eq.call('X', 'X').should == 1
			eq.call('X', "/").should == 0
			eq.call('/', "/").should == 1
			eq.call('X', "10").should == 0
			eq.call('3', "10").should == 0
			eq.call('3', "3").should == 1
		end

		it "'greater' compared numerically, with X as 10.8, and / as 10.2" do
			greater = @dsl.proc_from('greater')
			greater.call('9', '7').should == 1
			greater.call('7', '9').should == 0
			greater.call('X', '10').should == 1
			greater.call('/', '10').should == 1
			greater.call('X', '/').should == 1
			greater.call('X', '11').should == 0
			greater.call('5', '5').should == 0
		end

		context "when 'math'ing X and / resolve to 10 ..." do
			it "adding works as expected" do
				add = @dsl.proc_from('add')
				add.call("5", "X").should == 15
				add.call("/", "X").should == 20
				add.call("-3", "7").should == 4
			end
			it "subtracting works as expected" do
				subtract= @dsl.proc_from('subtract')
				subtract.call("5", "X").should == -5
				subtract.call("/", "X").should == 0
				subtract.call("-3", "7").should == -10
			end
			it "multiplying works as expected" do
				multiply = @dsl.proc_from('multiply')
				multiply.call("5", "X").should == 50
				multiply.call("/", "X").should == 100
				multiply.call("-3", "7").should == -21
			end
			it "dividing works as expected, erros to nil" do
				divide = @dsl.proc_from('divide')
				divide.call("5", "X").should == 0.5
				divide.call("/", "X").should == 1
				divide.call("-14", "7").should == -2
				divide.call("4", "0").should == nil
			end
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
