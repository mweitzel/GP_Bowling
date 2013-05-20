require_relative '../lib/clustering'
while(true)
	r = Clustering::RTalker.new
	arr = []
	100.times do
	arr.push({})
	end
	arr
	arr.each do
	|thing|
	thing["a"] = rand
	end
	i = 100
	arr.each do
	|thing|
	thing["b"] = rand * i
	i = i * 0.95
	end
	i = 100
	arr.each do |thing|
	i--
	thing["c"] = rand * (i/50)
	end
	r
	r.data_with_clusters_from(arr)
end
