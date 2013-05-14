
module Bowling
	
	class DSL
	
		def initialize
			@primatives = {
											'/'=>{},
											'X'=>{},
											'-1'=>{},
											'1'=>{},
											'2'=>{},
											'3'=>{},
											'4'=>{},
											'5'=>{},
											'6'=>{},
											'7'=>{},
											'8'=>{},
											'9'=>{},
											'0'=>{},
											'if'=>{},
											'if_eq'=>{},
											'if_greater'=>{},
											'if_less'=>{},
											'and'=>{},
											'or'=>{},
											'not'=>{},
											'pop'=>{},
											'eject'=>{},
											'peek_front'=>{},
											'peek_back'=>{},
											'add/sub/mult/div'=>{}
										}
		end

		def primatives
			@primatives
		end
	end

	class Interpreter
		
		def initialize(dsl, answer)
			@dsl = dsl
			@answer = answer.split(" ")
			@var_stack = []
		end
		
		def run_answer
			while(@answer.length > 0) do
				execute_next
			end
		end

		def execute_next
			proc_to_execute = @dsl.proc_from(@answer.shift)
			
			if proc_to_execute.parameters.length <= @var_stack.length
				#@var_stack.push proc_to_execute.call
				param_size = proc_to_execute.parameters.length
				params = []
				param_size.times do
					params.unshift(@var_stack.pop)
				end
				@var_stack.push proc_to_execute.call(*params)
			end
		end

		def dsl
			@dsl
		end

		def answer
			@answer
		end

		def var_stack
			@var_stack
		end
		
	end
end
