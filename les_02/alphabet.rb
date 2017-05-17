vowels = %w(a e i o u y)
letters = ('a'..'z')
hash = {}

letters.each.with_index(1) { |letter, index| hash[letter] = index if vowels.include?(letter) }
  
puts hash