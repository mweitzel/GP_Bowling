
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
																													if(p == 'X')
																															p = 10.8
																													elsif(p == '/')
																															p = 10.2
																													end
																													if(q == 'X')
																															q = 10.8
																													elsif(q == '/')
																															q = 10.2
																													end
																													(p.to_f > q.to_f) ? 1 : 0
																												}
																			},
											'if_less'=>{},
											'and'=>{},
											'or'=>{},
											'not'=>{},
											'pop'=>{:proc => Proc.new {|params = []|
																									params.pop	
																								}
														},
											'eject'=>{:proc => Proc.new {|params = []|
																									params.shift	
																								}
														},
											'peek_front'=>{:proc => Proc.new {|params = []|
																									params.first
																								}
														},
											'peek_back'=>{:proc => Proc.new {|params = []|
																									params.last
																								}
														},
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
			
			@primatives.include?(key) ?
				(@primatives[key][:proc] || Proc.new {key}) :
				Proc.new {}
		end

		private :resolve_as_number
	end	

	class Interpreter
		
		def initialize(dsl, answer, params = [])
			@dsl = dsl
			@answer = answer.split(" ")
			@parameters = params
			@var_stack = []
		end
		
		def run_answer
			while(@answer.length > 0) do
				execute_next
			end
			@var_stack.last.to_i
		end

		def execute_next
			proc_to_execute = @dsl.proc_from(@answer.shift)
			
			if proc_to_execute.arity.abs <= @var_stack.length
				params = []
				proc_to_execute.arity.abs.times do
					params.unshift(@var_stack.pop)
				end
				@var_stack.push(proc_to_execute.call(*params, @parameters))
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
