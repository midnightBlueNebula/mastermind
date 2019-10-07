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
        @pattern = []
        @not_guess_this = []
        @not_guess_this_in_same_pos = {}
        @not_move_this = {}
        @prev_guess = []
        @prev_guess_right = nil
        @prev_guess_wrong = nil
        @prev_guess_wrong_place = nil
        @in_pattern = []


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
        @pattern.each { |p| print " #{p} " }
        puts ""
    end

    def guessing
        if @player_turn == false
            start_board
            10.times do |r|
                color_placed_right = 0
                color_in_pattern = 0
                color_guessed_wrong = 0

                4.times do |c|
                    puts "Pick a color to guess pattern."
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
                print_board
                pattern_reveal
            end
        else
            start_board
            10.times do |r|
                guessed_colors = []
                color_placed_right = 0
                color_in_pattern = 0
                color_guessed_wrong = 0

                condition_matched = ""

                def which_condition_matched(condition)
                    condition_matched = condition
                end
                
                if @prev_guess_wrong == 4 || @prev_guess_wrong == nil
                    4.times do |c|
                        cpu_clr_guess = rand(11)
                        it = 0
                        if @not_guess_this.include?(@colors[cpu_clr_guess]) == true 
                            while @not_guess_this.include?(@colors[cpu_clr_guess]) == true && it < 10000
                                cpu_clr_guess = rand(11)
                                it += 1
                            end
                        end
                        @board[9-r][c] = @colors[cpu_clr_guess]
                        guessed_colors << @colors[cpu_clr_guess]
                    end
                    which_condition_matched("@prev_guess_wrong == 4 || @prev_guess_wrong == nil")
                elsif @prev_guess_wrong < 4 && @prev_guess_wrong >= 1
                    @prev_guess.each do |p|
                        iter_status = true
                        if @not_move_this.include?(p)==false && iter_status
                            clr_inx = rand(11)
                            while @colors[clr_inx] == p
                                clr_inx = rand(11)
                                p_new = @colors[clr_inx]
                                if @not_guess_this_in_same_pos[p_new] == @prev_guess.index(p_new)
                                    itr_i = 0
                                    while @colors[clr_inx] == p && @colors[clr_inx] == p_new && itr_i < 10000
                                        clr_inx = rand(11)
                                        itr_i += 10000
                                    end
                                end
                            end
                            inx = @prev_guess.index(p)
                            itr = 0
                            @prev_guess.each do |pr|
                                if pr == @prev_guess[inx]
                                    @board[9-r][itr] = @colors[clr_inx]
                                    guessed_colors << @colors[clr_inx]
                                    itr += 1
                                else
                                    @board[9-r][itr] = pr
                                    guessed_colors << pr
                                    itr += 1
                                end
                            end
                            iter_status = false
                        end
                        which_condition_matched("@prev_guess_wrong < 4 && @prev_guess_wrong >= 1")
                    end
                elsif @prev_guess_wrong_place == 4
                    itr = 0
                    @prev_guess.shuffle
                    while @prev_guess.any? { |p| @not_guess_this_in_same_pos[p] == @prev_guess.index(p) } && itr < 10000
                        @prev_guess.shuffle
                        itr += 1
                    end
                    it = 0
                    @prev_guess.each do |p|
                        @board[9-r][it] = p
                        guessed_colors << p
                        it += 1
                    end
                    which_condition_matched("@prev_guess_wrong_place == 4")
                else
                    4.times do |c|
                        cpu_clr_guess = rand(11)
                        if @not_guess_this.include?(@colors[cpu_clr_guess]) == true
                            itr = 0
                            while @not_guess_this.include?(@colors[cpu_clr_guess]) == true && itr < 10000
                                cpu_clr_guess = rand(11)
                                itr += 1
                            end
                        end
                        @board[9-r][c] = @colors[cpu_clr_guess]
                        guessed_colors << @colors[cpu_clr_guess]
                    end
                    which_condition_matched("else")
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

                if color_guessed_wrong == 4
                    guessed_colors.each { |g| @not_guess_this << g }
                elsif color_in_pattern == 4
                    iter = 0
                    guessed_colors.each do |g|
                        @not_guess_this_in_same_pos[g] == iter
                        iter += 1
                    end
                elsif color_guessed_wrong == 0
                    guessed_colors.each do |g|
                        if @not_guess_this.include?(g)
                            @not_guess_this.delete(g)
                        end
                    end
                end

                if @prev_guess_wrong != nil && @prev_guess_wrong_place != nil && @prev_guess_right != nil
                    if condition_matched == "@prev_guess_wrong < 4 && @prev_guess_wrong >= 1"
                        if color_guessed_wrong >= @prev_guess_wrong
                            guessed_colors.each do |e|
                                if @prev_guess.include?(e) == false
                                    @not_guess_this << e
                                end
                            end
                            @prev_guess.each do |e|
                                if @in_pattern.include?(e) == false
                                    @in_pattern << e
                                end
                                if @not_guess_this.include?(e)
                                    @not_guess_this.delete(e)
                                end
                            end
                        elsif color_in_pattern >= @prev_guess_wrong_place
                            guessed_colors.each do |e|
                                if @prev_guess.include?(e) == false && @in_pattern.include?(e) == false
                                    inx = guessed_colors.index(e)
                                    @not_guess_this_in_same_pos[e] = inx
                                    @in_pattern << e
                                end
                            end
                        elsif color_placed_right > @prev_guess_right
                            guessed_colors.each do |e|
                                if @prev_guess.include?(e) == false
                                    inx = guessed_colors.index(e)
                                    @not_move_this[e] = inx
                                    if @in_pattern.include?(e) == false
                                        @in_pattern << e
                                    end
                                end
                            end
                        end
                    end
                end

                @prev_guess_right = color_placed_right
                @prev_guess_wrong = color_guessed_wrong
                @prev_guess_wrong_place = color_in_pattern

                @prev_guess = []
                guessed_colors.each { |g| @prev_guess << g }

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
                print_board
                pattern_reveal
            end
        end
    end


    def game_on
        while @round_left > 0
            guessing
            @pattern = []
            if @player_turn 
               @player_turn = false 
            else
                @player_turn = true
            end
            @round_left -= 1
        end
    end

end

play_mastermind = Mastermind.new