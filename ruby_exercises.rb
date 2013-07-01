arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

arr.each do |e|
		puts e if e > 5		
end

puts arr.select {|e| e.odd?}
