class CodeMaker_and_Breaker
  attr_accessor :selection_feedback
  
  def initialize
    @colors = %w[blue green purple red yellow orange]
  
    @code_maker_selection = []
    @code_breaker_selection = []
    @selection_feedback = ['-', '-', '-', '-']
  
    @code_breaker_computer_save = []
  end
  
  def codemaker_computer
    4.times do
      @code_maker_selection.push(@colors.sample)
    end
  end
  
  def codemaker_user
    puts "\nEnter four colors (blue green purple red yellow orange) and the computer will try to break your code.\n\n"
    puts 'The first color you pick will be on the left and the next will be to the right of it, etc.'
    4.times do
      color = gets.chomp.downcase
  
      while @colors.any?(color) == false
        puts 'Make a selection from the available colors:'
        color = gets.chomp.downcase
      end
      @code_maker_selection.push(color)
    end
  end
  
  def codebreaker_computer
    @selection_feedback = ['-', '-', '-', '-']
    if @code_breaker_computer_save.empty?
      4.times do
        @code_breaker_selection.push(@colors.sample)
      end
    end
    p @code_breaker_selection
  end
  
  def codebreaker_computer_strategy
    i = 0
    @selection_feedback.each do |feedback|
      if feedback == 'Black'
        @code_breaker_computer_save[i] = @code_breaker_selection[i]
      elsif feedback.include?('White') || feedback.include?('-')
        @code_breaker_computer_save[i] = @colors.sample
      end
      i += 1
    end
    i = 0
    @code_breaker_selection = @code_breaker_computer_save.clone
  end
  
  def codebreaker_user
    puts 'Enter four colors (blue green purple red yellow orange) one at a time to make your guess:'
    @selection_feedback = ['-', '-', '-', '-']
    4.times do
      added_color = gets.chomp.downcase
  
      while @colors.any?(added_color) == false
        puts 'Make a selection from the available colors:'
        added_color = gets.chomp.downcase
      end
  
      @code_breaker_selection.push(added_color)
    end
  end
  
  def compare_codes
    compare_only_colors
    compare_color_and_index
    puts @selection_feedback.join(' ')
  end
  
  def compare_only_colors
    code_maker_selection_temp = @code_maker_selection.clone
    code_breaker_selection_temp = @code_breaker_selection.clone
  
    i = 0
    code_breaker_selection_temp.each do |b_color|
      j = 0
      code_maker_selection_temp.each do |m_color|
        if m_color == b_color
          @selection_feedback[i] = 'White'
          code_maker_selection_temp.delete_at(j)
          break
        end
        j += 1
      end
      i += 1
    end
    i = 0
  end
  
  def compare_color_and_index
    i = 0
  
    4.times do
      if @code_breaker_selection[i] == @code_maker_selection[i]
        @selection_feedback[i] = 'Black'
      end
      i += 1
    end
    i = 0
  end
 end
  
 class Game < CodeMaker_and_Breaker
  def initialize
    super
    @game_status = 'ongoing'
  end
  
  def choice_maker_or_breaker
    puts 'Type in maker or breaker if you want to be the code maker or the code breaker, respectively:'
    user_choice = gets.chomp.downcase
    if user_choice == 'maker'
      play_game_computer_breaker
    elsif user_choice == 'breaker'
      play_game_user_breaker
    else
      choice_maker_or_breaker
    end
  end
  
  def play_game_computer_breaker
    codemaker_user
    game_loop_computer_breaker
  end
  
  def play_game_user_breaker
    codemaker_computer
    game_loop_user_breaker
  end
  
  def game_loop_user_breaker
    x = 1
    while x <= 9
      if @selection_feedback == %w[Black Black Black Black]
        p 'Congratulations you have won!'
        break
      elsif x <= 8
        puts "Round: #{x} of 8\n"
        codebreaker_user
        compare_codes
        @code_breaker_selection = []
        x += 1
      elsif x == 9 && @selection_feedback == %w[Black Black Black Black]
        p 'Congratulations you have won!'
        break
      else
        puts 'You did not solve the computers code, please try again.'
        break
      end
    end
  end
  
  def game_loop_computer_breaker
    x = 1
    while x <= 9
      if @selection_feedback == %w[Black Black Black Black]
        p "The computer has figured out the code in #{x} rounds!"
        break
      elsif x == 9 && @selection_feedback == %w[Black Black Black Black]
        p "The computer has figured out the code in #{x} rounds!"
        break
      elsif x <= 8
        puts "Round: #{x} of 8\n"
        codebreaker_computer
        compare_codes
        codebreaker_computer_strategy
        x += 1
      else
        puts 'The computer could not figure out your code!'
        break
      end
    end
  end
 end
 puts "Instructions:\n\n"
 puts "Black feedback marker means both color and position are correct.\n\n"
 puts "White feedback marker means the color is in codemakers selection but not in the correct position.\n\n"
 puts "A - marker means that color is not in the codemakers selection.\n\n"
 puts "Feedback appears on one line and from left to right in the order you chose colors.\n\n"
  
 game = Game.new
 game.choice_maker_or_breaker
