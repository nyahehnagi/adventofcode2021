$LOAD_PATH << './lib'
require 'file_management.rb'
require 'benchmark'

include FileManagement

nav_system =  getData("data/inputday10.txt")

PARENS = {
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">"
  }

PARENS_SCORE = {
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }

AUTO_COMPLETE_SCORE = {
    ")" => 1,
    "]" => 2,
    "}" => 3,
    ">" => 4
  }
OPENING_PARENS = PARENS.keys
CLOSING_PARENS = PARENS.values

# PART 1
def score_invalid_parenthesis(nav)
    score = 0

    nav.each do |line| 
        open_brace_stack = []
        line.each_char do |ch|
            if OPENING_PARENS.include?(ch)
                open_brace_stack << ch
            elsif CLOSING_PARENS.include?(ch)
                if ch == PARENS[open_brace_stack.last] 
                    open_brace_stack.pop
                else
                    score += PARENS_SCORE[ch]
                    break
                end
            end
        end
    end

    return score
end


p score_invalid_parenthesis(nav_system)

# PART 2
def remove_bad_lines(nav)

    indices_to_delete = []
    nav.each_with_index do |line, idx| 
        open_brace_stack = []
        line.each_char do |ch|
            if OPENING_PARENS.include?(ch)
                open_brace_stack << ch
            elsif CLOSING_PARENS.include?(ch)
                if ch == PARENS[open_brace_stack.last] 
                    open_brace_stack.pop
                else
                    indices_to_delete << idx
                    break
                end
            end
        end
    end

    return nav.reject.each_with_index{|i, idx| indices_to_delete.include? idx }
   
end

no_bad_lines_nav =  remove_bad_lines(nav_system)

def find_scores(nav)

    autocomplete_scores = []
    missing_parens = []
    nav.each_with_index do |line, idx| 
        open_brace_stack = []
        line.each_char do |ch|
            if OPENING_PARENS.include?(ch)
                open_brace_stack << ch
            elsif CLOSING_PARENS.include?(ch)
                if ch == PARENS[open_brace_stack.last] 
                    open_brace_stack.pop
                end
            end
        end
        # what's left on the stack needs a corresponding closing paren
        autocomplete = ""
        score = 0
        until open_brace_stack.empty?
            ch = open_brace_stack.pop
            score *= 5
            score += AUTO_COMPLETE_SCORE[PARENS[ch]]
        end
        autocomplete_scores << score
    end

     autocomplete_scores.sort!
     midpoint = (autocomplete_scores.length/2).floor
 
     return autocomplete_scores[midpoint]
   
end

p score = find_scores(no_bad_lines_nav)

