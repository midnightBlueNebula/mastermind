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

        game_on
    end

    private

    def start_board
        p_row = 0
        p_col = 0
        while p_row < 4
            p_row_store = []
            while p_col < 4
                p_row_store << p_row.to_s + p_col.to_s
                p_col += 1
            end
            @board << p_row_store
            p_row += 1
        end
    end

    def print_board
        
    end

    def show_board_to_player
        if @player_turn
            print_board
        else
            "Computer's turn as codemaker can't show board now."
        end
    end

    def game_on
        while @round_left > 0
            start_board
            show_board_to_player

            while @guess_left > 0

                @guess_left -= 1
            end
            
            @round_left -= 1
        end
    end

end