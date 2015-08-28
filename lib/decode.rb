require "pry"

def decode(msg)
  original = msg
  if repeated_chars?(msg)
    msg = transform(msg)
    decode(msg)
  else
    msg
  end
end

def repeated_chars?(msg)
  msg.split("").uniq != msg.split("")
end

def transform(msg)
  msg = remove_underscores(msg)
  spans = char_spans(msg)
  pair = spans.max_by{|span| span[:to] - span[:from]}
  chars = msg.split("")
  chars.delete_at(pair[:from])
  chars.delete_at(pair[:to] - 1)
  chars << pair[:char]
  # binding.pry
  chars.join("")
end

def char_spans(msg)
  spans = []
  chars = msg.split("")
  chars.each.with_index do |char, i|
    # does not execute on the last character
    if i < chars.length
      # executes if rest of string includes char
      substring = chars[i+1..-1]
      if substring.include?(char)
        next_idx = chars[i+1..-1].index(char) + i + 1
        char_span = chars[i+1...next_idx]
        # only records spans that do not contain duplicates
        if char_span.uniq == char_span 
          spans << {char: char, from: i, to: next_idx}
        end
      end
    end
  end
  spans
end

def distance_between_chars(a, b)
  a_index
end

def remove_underscores(msg)
  underscore_idx = msg.index("_")
  underscore_idx ? msg[0...underscore_idx] : msg
end