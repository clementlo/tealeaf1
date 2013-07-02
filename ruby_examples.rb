#1. Use the "each" method of Array to iterate over [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], and print out each value.
a = [1, 2 ,3 ,4 ,5 ,6 ,7 ,8 ,9 ,10, 5, 3, 1, 3, 2]
a.each do |e| 
	puts e
end

#2. Same as above, but only print out values greater than 5.
a.each do |e|
	puts e if e > 5
end

#3. Now, using the same array from #2, use the "select" method to extract all odd numbers into a new array.
b = []
a.each do |e|
	if e%2 == 1
		b.push e
	end
end
puts b

puts a.select {|e| e.odd?}

#4. Append "11" to the end of the array. Prepend "0" to the beginning.
a.push 11
a.unshift 0

#5. Get rid of "11". And append a "3".
a.pop
a.push 3

#6. Get rid of duplicates without specifically removing any one value. 
puts a.uniq {|e| e}

#8. Create a Hash using both Ruby 1.8 and 1.9 syntax.
c = {:a => 5, :b => 'fun', :c => 1}
puts c

d = {a: 5, b: 'fun', c: 1 }
puts d

#9. Get the value of key "b".
h = {a:1, b:2, c:3, d:4}

puts h[:b]

#10. Add to this hash the key:value pair {e:5}
h[:e] = 5

#13. Remove all key:value pairs whose value is less than 3.5
h.delete_if {|e, v| v < 3.5 }
puts h

h[:a] = a
puts h

#14. Can hash values be arrays? Can you have an array of hashes? (give examples)
arrh = [{x: "hi", y: "yo"}, 5, 3]
puts arrh






