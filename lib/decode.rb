require "pry"

def decode(message)
  while has_pairs?(message)
    pairs_hash = distance_between_characters(message)
    char = pairs_hash.max_by {|letter, span| span}[0]
    pair_indices = find_char_indices(char, message)
    message = transform_message(pair_indices, message)
  end
  message
end

def distance_between_characters(msg)
  spans = {}
  chars = msg.split("")
  chars.each_with_index do |a, i|
    span = 0
    if spans[a].nil?
      chars[i..-1].each_with_index do |b, j|
        if j > 0 && a == b
          char_span = chars[i+1...j]
          span = j if !(duplicate_chars?(char_span))
        end
      end
      spans[a] = span
    end
  end
  spans
end

def duplicate_chars?(char_span)
  char_span.uniq != char_span
end

def find_char_indices(char, msg)
  first_idx = msg.index(char)
  last_idx = msg.rindex(char)
  [first_idx, last_idx]
end

def transform_message(indices, msg)
  msg = msg.split("")
  first_idx = indices[0]
  last_idx = indices[1]
  char = msg[first_idx]
  msg.delete_at(first_idx)
  msg.delete_at(last_idx-1)
  msg << char
  msg*""
end

def has_pairs?(msg)
  !(msg.split("").uniq == msg.split(""))
end