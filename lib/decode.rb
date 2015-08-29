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
  spans = char_spans(msg)
  spans = spans.sort do |a, b|
    b[:length] <=> a[:length]
  end
  # binding.pry if msg == "aaccfgeb"
  if spans.size > 1 && spans[0][:length] == spans[1][:length]
    pair = spans[0..1].min{|a, b| a[:from] <=> b[:from]}
  else
    pair = spans[0]
  end
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
        substring.each.with_index do |sub, j|
          char_sub = chars[i+1..j-1].join("")
          if char == sub && (!(repeated_chars?(char_sub)) || j == 0)
            next_idx = j + i + 1
            char_span = chars[i+1...next_idx]      
            spans << {char: char, from: i, to: next_idx, length: next_idx - i, span: chars[i..next_idx]*""} if char_span.uniq == char_span       
          end
        end
      end
    end
  end
  spans
end

def remove_underscores(msg)
  underscore_idx = msg.index("_")
  underscore_idx ? msg[0...underscore_idx] : msg
end