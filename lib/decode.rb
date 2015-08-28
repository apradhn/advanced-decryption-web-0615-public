require "pry"

def decode(msg)
  original = msg
  repeated_chars?(msg) ? decode(transform(msg)) : remove_underscores(msg)
end

def repeated_chars?(msg)
  msg.split("").uniq != msg.split("")
end

def transform(msg)
  spans = char_spans(msg)
  pair = spans.max_by{|span| span[:to] - span[:from]}
  chars = msg.split("")
  chars.delete_at(pair[:from])
  chars.delete_at(pair[:to] - 1)
  chars << pair[:char]
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
        spans << {char: char, from: i, to: next_idx} if char_span.uniq == char_span 
      end
    end
  end
  spans
end

def remove_underscores(msg)
  underscore_idx = msg.index("_")
  underscore_idx ? msg[0...underscore_idx] : msg
end