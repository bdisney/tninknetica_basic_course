vowels = %w(a e i o u y)
letters = ('a'..'z')
hash = {}

letters.each_with_index do |letter, index|
  if vowels.include?(letter)
    hash[letter] = index + 1
  end
end

puts hash

