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
        @cpu_points = 0
        @player_points = 0


        game_on
    end

    private

    def start_board
        @colors = ["blue","cyan","purple","pink","red","yellow","green","gray","black","brown","white"]
        @guess_pool = ["blue","cyan","purple","pink","red","yellow","green","gray","black","brown","white"]
        @pattern = []
        @not_guess_this = []
        @not_guess_this_in_same_pos = {}
        @not_move_this = {}
        @prev_guess = []
        @prev_guess_right = nil
        @prev_guess_wrong = nil
        @prev_guess_wrong_place = nil


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
        puts ""
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
                @guess_pool.uniq!
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
                        pool = @guess_pool.length
                        cpu_clr_guess = rand(pool)
                        it = 0
                        @board[9-r][c] = @guess_pool[cpu_clr_guess]
                        guessed_colors << @guess_pool[cpu_clr_guess]
                    end
                    which_condition_matched("@prev_guess_wrong == 4 || @prev_guess_wrong == nil")
                elsif @prev_guess_wrong < 4 && @prev_guess_wrong >= 1
                    @prev_guess.each do |p|
                        iter_status = true
                        iter = 0
                        if @not_move_this.include?(p)==false && iter_status
                            pool = @guess_pool.length
                            clr_inx = rand(pool)
                            it_w = 0
                            while @guess_pool[clr_inx] == p
                                clr_inx = rand(pool)
                                p_new = @guess_pool[clr_inx]
                                if @not_guess_this_in_same_pos[p_new] == @prev_guess[it_w]
                                    itr_i = 0
                                    while (@guess_pool[clr_inx] == p || @guess_pool[clr_inx] == p_new) && itr_i < 10000
                                        clr_inx = rand(pool)
                                        itr_i += 1
                                    end
                                end
                                it_w += 1
                            end
                            itr = 0
                            @prev_guess.each do |pr|
                                if itr == iter
                                    @board[9-r][itr] = @guess_pool[clr_inx]
                                    guessed_colors << @guess_pool[clr_inx]
                                    itr += 1
                                else
                                    @board[9-r][itr] = pr
                                    guessed_colors << pr
                                    itr += 1
                                end
                            end
                            iter_status = false
                        end
                        iter += 1
                    end
                    which_condition_matched("@prev_guess_wrong < 4 && @prev_guess_wrong >= 1")
                elsif @prev_guess_wrong_place == 4
                    iter = 0
                    @prev_guess.each do |p|
                        @not_guess_this_in_same_pos[p] == iter
                        if @guess_pool.include?(p) == false
                            @guess_pool.delete(p)
                        end
                        iter += 1
                    end
                    p = @prev_guess.shift
                    @prev_guess.push(p)
                    it = 0
                    @prev_guess.each do |p|
                        @board[9-r][it] = p
                        guessed_colors << p
                        it += 1
                    end
                    which_condition_matched("@prev_guess_wrong_place == 4")
                elsif @prev_guess_right < 4 && @prev_guess_right > 0 && @prev_guess_wrong == 0
                    iter_status = true
                    iter = 0
                    @prev_guess.each do |p|
                        clr_inx
                        if @not_move_this.include?(p) == false && iter_status == true
                            pool = @guess_pool.length
                            clr_inx = rand(pool)
                            it = 0
                            while (p == @guess_pool[clr_inx] ||  @not_guess_this_in_same_pos[@guess_pool[clr_inx]] == @prev_guess[iter]) && it < 10000
                                clr_inx = rand(pool)
                                it += 1
                            end
                            iter_status = false
                            inx = iter
                        end
                        if inx == iter
                            @board[9-r][iter] = @guess_pool[clr_inx]
                            guessed_colors << @guess_pool[clr_inx]
                        else
                            @board[9-r][iter] = p
                            guessed_colors << p
                        end
                        iter += 1
                    end
                    which_condition_matched("@prev_guess_right < 4 && @prev_guess_right > 0")
                elsif @prev_guess_wrong_place < 4 && @prev_guess_wrong_place > 0 && @prev_guess_wrong == 0
                    iter_status = true
                    iter = 0
                    @prev_guess.each do |p|
                    end
                    which_condition_matched("@prev_guess_wrong_place < 4 && @prev_guess_wrong_place > 0 && @prev_guess_wrong == 0")
                else
                    4.times do |c|
                        pool = @guess_pool.length
                        cpu_clr_guess = rand(pool)
                        @board[9-r][c] = @guess_pool[cpu_clr_guess]
                        guessed_colors << @guess_pool[cpu_clr_guess]
                    end
                    which_condition_matched("else")
                end

                4.times do |c|
                    if @board[9-r][c] == @pattern[c]
                        color_placed_right += 1
                    elsif @pattern.include?(@board[9-r][c]) && @board[9-r][c] != @pattern[c]
                        color_in_pattern += 1
                    else
                        color_guessed_wrong += 1
                    end
                end

                if color_guessed_wrong == 4
                    guessed_colors.each { |g| @guess_pool.delete(g) }
                elsif color_in_pattern == 4
                    iter = 0
                    guessed_colors.each do |g|
                        @not_guess_this_in_same_pos[g] == iter
                        iter += 1
                    end
                elsif color_placed_right == 0
                    iter = 0
                    guessed_colors.each do |g|
                        @not_guess_this_in_same_pos[g] = iter
                        iter += 1
                    end
                end

                if @prev_guess_wrong != nil && @prev_guess_wrong_place != nil && @prev_guess_right != nil
                    if condition_matched == "@prev_guess_wrong < 4 && @prev_guess_wrong >= 1"
                        if color_guessed_wrong > @prev_guess_wrong
                            guessed_colors.each do |e|
                                if @prev_guess.include?(e) == false && @guess_pool.include?(e) == false
                                    @guess_pool.delete(e)
                                end
                            end
                            @prev_guess.each do |e|
                                it = 0
                                if guessed_colors.include?(e) == false && color_in_pattern < @prev_guess_wrong_place
                                    if @guess_pool.include?(e) == false
                                        @guess_pool << e
                                    end
                                    @not_guess_this_in_same_pos[e] = it
                                elsif guessed_colors.include?(e) == false && color_placed_right < @prev_guess_right
                                    if @guess_pool.include?(e) == false
                                        @guess_pool << e
                                    end
                                    @not_move_this[e] = it
                                end
                                it += 1
                            end
                        elsif color_guessed_wrong < @prev_guess_wrong && color_placed_right > @prev_guess_right
                            it = 0
                            guessed_colors.each do |e|
                                if @prev_guess.include?(e) == false
                                    @not_move_this[e] = it
                                    if @guess_pool.include?(e) == false
                                        @guess_pool << e
                                    end
                                end
                                it += 1
                            end
                        elsif color_guessed_wrong < @prev_guess_wrong && color_in_pattern > @prev_guess_wrong_place
                            it = 0
                            guessed_colors.each do |e|
                                if @prev_guess.include?(e) == false
                                    @not_guess_this_in_same_pos[e] = it
                                end
                                it += 1
                            end
                        elsif color_in_pattern >= @prev_guess_wrong_place
                            it_e = 0
                            guessed_colors.each do |e|
                                if @prev_guess.include?(e) == false && @guess_pool.include?(e) == false
                                    @not_guess_this_in_same_pos[e] = it_e
                                    @guess_pool << e
                                end
                                it_e += 1
                            end
                        elsif color_placed_right > @prev_guess_right
                            it_e = 0
                            guessed_colors.each do |e|
                                if @prev_guess.include?(e) == false
                                    @not_move_this[e] = it_e
                                    if @guess_pool.include?(e) == false
                                        @guess_pool << e
                                    end
                                end
                                it_e += 1
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