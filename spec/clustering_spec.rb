require 'spec_helper'

describe Clustering do
	
	before(:each) do
		@r_talker = Clustering::RTalker.new
		clear_test_files
	end

	after(:each) do
		clear_test_files
	end
	
	def clear_test_files 
		files = []
		files.push(Clustering::RTalker.new.input_file_name)
		files.push(Clustering::RTalker.new.output_file_name)

		files.each do |file_name|
			File.delete(file_name) rescue
			File.exist?(file_name).should be_false
		end
	end
	
	it "can cluster data into a usable way to be written to csv" do
		data = []
		data.push({"criteria_a" => 1, "criteria_b" => 2, "criteria_c" => 3})
		data.push({"criteria_a" => 4, "criteria_b" => 5, "criteria_c" => 6})
		data.push({"criteria_a" => 7, "criteria_b" => 8, "criteria_c" => 9})
		expected ="criteria_a,criteria_b,criteria_c\n1,2,3\n4,5,6\n7,8,9\n"
		@r_talker.format_for_input(data).should == expected
	end

	it "can write R input data into a file within a temp folder" do
		
		temp_data = "blabla blaaaaaarghishbarg!"

		@r_talker.write_input_as_file(temp_data)

		file = File.open(@r_talker.input_file_name, "r")
		file_content = ""
		while (line = file.gets)
			file_content += line
		end
		file.close
		
		file_content.should == temp_data
		
	end
	
	it "can read formatted data from a file" do
		file = File.new(@r_talker.output_file_name, "w")
		data = []
		data.push({"criteria_a" => 1, "criteria_b" => 2, "criteria_c" => 3})
		data.push({"criteria_a" => 4, "criteria_b" => 5, "criteria_c" => 6})
		data.push({"criteria_a" => 7, "criteria_b" => 8, "criteria_c" => 9})

		potential_output = '"","x"
"1",1
"3",3
"4",2'
		file.write(potential_output)
		file.close

		clusters = @r_talker.clusters_from_r_output
		clusters.should == [1,3,2]

		expected_compiled_data = []
		expected_compiled_data.push({"criteria_a" => 1, "criteria_b" => 2, "criteria_c" => 3, "cluster" => 1})
		expected_compiled_data.push({"criteria_a" => 4, "criteria_b" => 5, "criteria_c" => 6, "cluster" => 3})
		expected_compiled_data.push({"criteria_a" => 7, "criteria_b" => 8, "criteria_c" => 9, "cluster" => 2})

		@r_talker.data_with_clusters(data, clusters).should == expected_compiled_data
	end
	
	it "should be able to start with input data, and end up with cluster information for it" do
		data = []
		data.push({"criteria_a" => 1, "criteria_b" => 2, "criteria_c" => 3})
		data.push({"criteria_a" => 4, "criteria_b" => 5, "criteria_c" => 6})
		data.push({"criteria_a" => 7, "criteria_b" => 8, "criteria_c" => 9})
		
		expected_compiled_data = []
		expected_compiled_data.push({"criteria_a" => 1, "criteria_b" => 2, "criteria_c" => 3, "cluster" => 1})
		expected_compiled_data.push({"criteria_a" => 4, "criteria_b" => 5, "criteria_c" => 6, "cluster" => 3})
		expected_compiled_data.push({"criteria_a" => 7, "criteria_b" => 8, "criteria_c" => 9, "cluster" => 2})

		@r_talker.data_with_clusters_from(data).should == expected_compiled_data
	end

	it "should give the R script input in a useful way" do
		pending
	end

	pending "should call the R script"
	pending "should retrieve only the valuable information from R"

	pending "should be able to correlate that information to the memory data currently floating around"

	pending "should be able to request a classification jpg from R, but by default"
	

end
