require 'spec_helper'

describe Bowling do
	
	context "Scoring Language" do

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
		
		it "swaps top two elements" do
			@dsl.proc_from('swap').call("left", "right").should == ['right','left']
		end
	
		pending "perhaps include some loop"
		pending "perhaps include a way to reference either vars or executable tokens"
		pending "perhaps include a way to return either vars or executable tokens"

		context "can access the entirety of input" do
			
			before(:each) do
				@params = [1,2,3,4,5]
			end
			
			pending "confirms arity is zero even though they access a param"
			
			it "pop" do
				@dsl.proc_from('pop').call(@params).should == 5
				@params.should == [1,2,3,4]
			end

			it "eject" do
				@dsl.proc_from('eject').call(@params).should == 1
				@params.should == [2,3,4,5]
			end

			it "peek_front" do
				@dsl.proc_from('peek_front').call(@params).should == 1
				@params.should == [1,2,3,4,5]
			end

			it "peek_back" do
				@dsl.proc_from('peek_back').call(@params).should == 5
				@params.should == [1,2,3,4,5]
			end
			
			it "should return nil if a language piece isn't defined and is asked for" do
				@dsl.proc_from('doesnt_exist').call.should == nil

			end

		end
		
	end

end
