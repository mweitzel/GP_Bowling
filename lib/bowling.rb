
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
											'if'=>{:proc => Proc.new {|bool, value|
																									if (bool.to_i > 0 || bool == 'X' || bool == '/')
																										value
																									else
																										nil
																									end
																								}
															},
											'eq'=>{:proc => Proc.new {|p, q|
																											if(p.to_s == q.to_s)
																												1
																											else
																												0
																											end
																										}
																},
											'greater'=>{:proc => Proc.new {|p, q|
																													if(p.to_s == 'X')
																															p = 10.8
																													elsif(p.to_s == '/')
																															p = 10.2
																													end
																													if(q.to_s == 'X')
																															q = 10.8
																													elsif(q.to_s == '/')
																															q = 10.2
																													end

																													if(p.to_f > q.to_f)
																														1
																													else
																														0
																													end
																												}
																			},
											'if_less'=>{},
											'and'=>{},
											'or'=>{},
											'not'=>{},
											'pop'=>{},
											'eject'=>{},
											'peek_front'=>{},
											'peek_back'=>{},
											'swap'=>{:proc => Proc.new { |x, y|
																										[y,x]
																									}
															},
											'add'=>{:proc => Proc.new { |x, y|
																										x = resolve_as_number(x)
																										y = resolve_as_number(y)
																										x + y
																									}
															},
											'subtract'=>{:proc => Proc.new { |x, y|
																										x = resolve_as_number(x)
																										y = resolve_as_number(y)
																										x - y
																									}
															},
											'multiply'=>{:proc => Proc.new { |x, y|
																										x = resolve_as_number(x)
																										y = resolve_as_number(y)
																										x * y
																									}
															},
											'divide'=>{:proc => Proc.new { |x, y|
																										x = resolve_as_number(x)
																										y = resolve_as_number(y)
																										if(y == 0)
																											nil
																										else
																											a = x / y
																										end
																									}
															},
										}
		end
		
		def resolve_as_number(key)
			if(key.to_s == "X" || key.to_s == '/')
				return 10
			else
				return key.to_f
			end
		end

		def primatives
			@primatives
		end
		
		def proc_from(key)

			@primatives[key][:proc] || Proc.new {key}
				
		end

		private :resolve_as_number
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
				params = []
				proc_to_execute.parameters.length.times do
					params.unshift(@var_stack.pop)
				end
				@var_stack.push(proc_to_execute.call(*params))
				@var_stack.flatten!
				@var_stack.compact!
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
