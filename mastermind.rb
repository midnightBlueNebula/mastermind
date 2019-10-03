class Mastermind
    def initialize
        toss = rand(2)
        if toss == 0
            @player_turn = true
        else
            @player_turn = false
        end
        @board = []
        @round_left = 4
        @guess_left = 10
        @cpu_points = 0
        @player_points = 0
        @colors = ["blue","cyan","purple","pink","red","yellow","green","gray","black","brown","white"]
        @options = []
        @pattern = []

        game_on
    end

    private

    def start_board
        s_row = 0
        s_col = 0
        while s_row < 10
            s_row_store = []
            while s_col < 4
                s_row_store << s_row.to_s + s_col.to_s
                @options << s_row.to_s + s_col.to_s
                s_col += 1
            end
            @board << s_row_store
            s_col = 0
            s_row += 1
        end

        print_board
        
        if @player_turn
            
            puts "You are codemaker in this turn."
            puts "To create your pattern..."

            4.times do
                puts "Pick a color:"
                color_print_iter = 0
                @colors.each do |c| 
                    puts "For #{c} enter: #{color_print_iter}. "
                    color_print_iter += 1
                end
                print "\n"
                color = gets.chomp
                color = color.to_i
                if color.kind_of?(Integer) == false || color < 0 || color >= @colors.length
                    while color.kind_of?(Integer) == false || color < 0 || color >= @colors.length
                        puts "Invalid option inputted. Please try again."
                        color = gets.chomp
                        color = color.to_i
                    end
                end
                @pattern << @colors[color]
            end
            pattern_reveal

        else
            puts "You're codebreaker in this turn."
            4.times do
                cpu_pattern_pick = rand(11)
                @pattern << @colors[cpu_pattern_pick]
            end
        end
    end

    def print_board
        p_row = 0
        p_col = 0
        while p_row < 10
            puts "-----------------------------------------------------"
            while p_col < 4
                print "|"
                print " " * (7-@board[p_row][p_col].length)
                print @board[p_row][p_col]
                print " " * (7-@board[p_row][p_col].length)
                if @board[p_row][p_col].length > 2
                    print " " * (@board[p_row][p_col].length-2)
                end
                p_col += 1
            end
            print "|"
            print "\n"
            p_col = 0
            p_row += 1
        end
        puts "-----------------------------------------------------"
    end


    def pattern_reveal
        puts @pattern
    end

    def guessing
        if @player_turn == false
            10.times do |r|
                color_placed_right = 0
                color_in_pattern = 0
                color_guessed_wrong = 0

                4.times do |c|
                    puts "Pick a color to guess pattern"
                    puts ""
                    puts "Pick a color:"
                    color_print_iter = 0
                    @colors.each do |clr| 
                        puts "For #{clr} enter: #{color_print_iter}. "
                        color_print_iter += 1
                    end
                    print "\n"
                    color = gets.chomp
                    color = color.to_i
                    if color.kind_of?(Integer) == false || color < 0 || color >= @colors.length
                        while color.kind_of?(Integer) == false || color < 0 || color >= @colors.length
                            puts "Invalid option inputted. Please try again."
                            color = gets.chomp
                            color = color.to_i
                        end
                    end
                    @board[9-r][c] = @colors[color]
                    print_board
                end

                4.times do |c|
                    if @board[9-r][c] == @pattern[c]
                        color_placed_right += 1
                    elsif @pattern.include?(@board[9-r][c])
                        color_in_pattern += 1
                    else
                        color_guessed_wrong += 1
                    end
                end

                puts ""
                print "#{color_placed_right} color"
                print color_placed_right > 1 ? "s " : " "
                print "placed right.\n"
                print "#{color_in_pattern} color"
                print color_in_pattern > 1 ? "s " : " "
                print "exist in patern but placed wrong.\n"
                print "#{color_guessed_wrong} color"
                print color_guessed_wrong > 1 ? "s " : " "
                print "guessed wrong.\n"
                pattern_reveal
            end
        else
            10.times do |r|
                color_placed_right = 0
                color_in_pattern = 0
                color_guessed_wrong = 0
                4.times do |c|
                    cpu_clr_guess = rand(11)
                    @board[9-r][c] = @colors[cpu_clr_guess]
                end

                4.times do |c|
                    if @board[9-r][c] == @pattern[c]
                        color_placed_right += 1
                    elsif @pattern.include?(@board[9-r][c])
                        color_in_pattern += 1
                    else
                        color_guessed_wrong += 1
                    end
                end

                puts ""
                print "#{color_placed_right} color"
                print color_placed_right > 1 ? "s " : " "
                print "placed right.\n"
                print "#{color_in_pattern} color"
                print color_in_pattern > 1 ? "s " : " "
                print "exist in patern but placed wrong.\n"
                print "#{color_guessed_wrong} color"
                print color_guessed_wrong > 1 ? "s " : " "
                print "guessed wrong.\n"
                pattern_reveal
            end
        end
    end


    def game_on
        while @round_left > 0
            start_board
            guessing
            @pattern = []

            while @guess_left > 0

                @guess_left -= 1
            end
            
            @round_left -= 1
        end
    end

end

play_mastermind = Mastermind.new