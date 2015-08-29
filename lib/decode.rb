require "pry"

def decode(msg)
  original = msg
  if repeated_chars?(msg)
    decode(transform(msg))
  else
    remove_underscores(msg)
  end
end

def repeated_chars?(msg)
  msg.split("").uniq != msg.split("")
end

def transform(msg)
  pair = longest_char_span(msg)
  chars = msg.split("")
  chars.delete_at(pair[:from])
  chars.delete_at(pair[:to] - 1)
  chars << pair[:char]
  chars.join("")
end

def longest_char_span(msg)
  max_span = {length: 0}
  chars = msg.split("")
  chars.each.with_index do |char, i|
    # does not execute on the last character
    if i < chars.length
      # executes if rest of string includes char
      substring = chars[i+1..-1]    
      substring.each.with_index do |sub, j|
        next_idx = j + i + 1
        span = {char: char, from: i, to: next_idx, length: next_idx - i}
        char_span = chars[i+1...next_idx] 
        if char == sub
          if span[:length] > max_span[:length] && (j == 0 || char == sub && char_span.uniq == char_span)
            max_span = span
          elsif span[:length] == max_span[:length] && span[:from] < max_span[:from]
            max_span = span
          end
        end
      end
    end
  end
  max_span
end

def remove_underscores(msg)
  underscore_idx = msg.index("_")
  underscore_idx ? msg[0...underscore_idx] : msg
end