require 'CSV'
module Clustering
	
	class RTalker
		
		def initialize
			@input_file_name = "temp/input.csv"
			@output_file_name = "temp/output.csv"
		end

		def data_with_clusters_from(data)
			input_string = format_for_input(data)
			write_input_as_file(input_string)

		end

		def format_for_input (object_array)
			keys = object_array.first.keys
			string_for_input = keys.to_a.join(',') + "\n"

			object_array.each do |answer_criteria|
				row = []
				keys.each do |key|
					row.push(answer_criteria[key])
				end
				string_for_input += row.join(',') + "\n"
			end
			string_for_input
		end

		def write_input_as_file(formatted_data)
			file = File.new(@input_file_name, "w")
			file.write(formatted_data)
			file.close
		end

		def clusters_from_r_output
			data = []
			CSV.foreach(@output_file_name) do |row|
				data.push(row)
			end
			data.shift
			clusters = []
			data.each do |row|
				clusters.push(row.last.to_i)
			end
			clusters
		end

		def data_with_clusters(data, clusters)
			compiled_data = []
			data.each_index do |i|
				data_point = data[i]
				data_point["cluster"] = clusters[i]
			end
			data
		end
	
		def input_file_name
			@input_file_name
		end
		
		def output_file_name
			@output_file_name
		end

	end

end
