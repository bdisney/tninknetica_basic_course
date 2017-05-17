puts "Enter text:"
text = gets.strip

words = text.split
frequencies = Hash.new(0)

words.each { |word| frequencies[word] += 1 }

frequencies = frequencies.sort_by do |word, count|
  count
end

frequencies.reverse!

frequencies.each do |words, count|
  puts words + " " + count.to_s
end