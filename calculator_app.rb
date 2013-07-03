def message(msg)
  puts "#{msg}"
end

message "What's the first number?"
num1 = gets.chomp

message "What's the second number?"
num2 = gets.chomp

message "What type of operation would you like to do?"
message "1: Add  2: Subtract  3: Multiply  4: Divide"
operator = gets.chomp
result = nil

if operator == "1"
  result = num1.to_i + num2.to_i
  message "The result is #{result}"
elsif  operator == "2"
  result = num1.to_i - num2.to_i
  message "The result is #{result}"
elsif operator == "3"
  result = num1.to_i * num2.to_i
  message "The result is #{result}"
elsif operator == "4"
  result = num1.to_f / num2.to_f
  message "The result is #{result}"
else
    "Please enter a valid selection."
end
