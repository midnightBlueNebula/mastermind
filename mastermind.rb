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
        @guess_left = 12
        @cpu_points = 0
        @player_points = 0
        @colors = ["blue","cyan","purple","pink","red","yellow","green","torquoise","black","brown","white"]
        @options = []
        @taken = []

        game_on
    end

    private

    def start_board
        if @player_turn
            s_row = 0
            s_col = 0
            while s_row < 4
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
            
            puts "You are codemaker in this turn."

            while @taken.length < 16
                puts "Pick a color:"
                color_print_iter = 0
                @colors.each do |c| 
                    print "For #{c} enter: #{color_print_iter}. "
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
                puts "Where would you like to place #{@colors[color]}?"
                print_board
                place = gets.chomp
                if @options.include?(place) == false || @taken.include?(place) == true
                    while @options.include?(place) == false || @taken.include?(place) == true
                        puts "Invalid option inputted. Please try again."
                        place = gets.chomp
                    end
                end
                p_choice = place.split("")
                p_row_choice = p_choice[0].to_i
                p_col_choice = p_choice[1].to_i
                @board[p_row_choice][p_col_choice] = @colors[color]
                @taken << place
            end

        else
            cpu_row = 0
            cpu_col = 0
            while cpu_row < 4
                while cpu_col < 4
                    cpu_pick = rand(11)
                    @board[cpu_row][cpu_col] = @colors[cpu_pick]
                    cpu_col += 1
                end
                cpu_col = 0
                cpu_row += 1
            end
            print_board
        end
    end

    def print_board
        p_row = 0
        p_col = 0
        while p_row < 4
            puts "---------------------------------------------"
            while p_col < 4
                print "|    #{@board[p_row][p_col]}    "
                p_col += 1
            end
            print "|"
            print "\n"
            p_col = 0
            p_row += 1
        end
        puts "---------------------------------------------"
    end

    def show_board_to_player
        if @player_turn
            print_board
        else
            puts "Computer's turn as codemaker can't show board now."
        end
    end

    def game_on
        while @round_left > 0
            start_board
            @taken = []
            show_board_to_player

            while @guess_left > 0

                @guess_left -= 1
            end
            
            @round_left -= 1
        end
    end

end

play_mastermind = Mastermind.new