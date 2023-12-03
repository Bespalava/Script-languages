#!/bin/bash

declare -a board=(" " " " " " " " " " " " " " " " " ")

function print_numbered_board() {
    echo "  Pattern "
    echo " 1 | 2 | 3 "
    echo "---|---|---"
    echo " 4 | 5 | 6 "
    echo "---|---|---"
    echo " 7 | 8 | 9 "
}

function print_game_board() {
    echo " Game Board"
    echo " ${board[0]} | ${board[1]} | ${board[2]} "
    echo "---|---|---"
    echo " ${board[3]} | ${board[4]} | ${board[5]} "
    echo "---|---|---"
    echo " ${board[6]} | ${board[7]} | ${board[8]} "
}

function print_info() {
    echo " Enter 'q' to exit, enter 's' to save the game"
}

function print_board() {
    clear
    print_numbered_board
    echo ""
	print_info
	echo ""
    print_game_board
}

function check_winner() {
    local player=$1
    for i in 0 1 2; do
        if [ "${board[$i]}" == "$player" ] && [ "${board[$((i+3))]}" == "$player" ] && [ "${board[$((i+6))]}" == "$player" ]; then
            echo "Player $player wins!"
            exit 0
        fi
        if [ "${board[$((i*3))]}" == "$player" ] && [ "${board[$((i*3+1))]}" == "$player" ] && [ "${board[$((i*3+2))]}" == "$player" ]; then
            echo "Player $player wins!"
            exit 0
        fi
    done
    if [ "${board[0]}" == "$player" ] && [ "${board[4]}" == "$player" ] && [ "${board[8]}" == "$player" ]; then
        echo "Player $player wins!"
        exit 0
    fi
    if [ "${board[2]}" == "$player" ] && [ "${board[4]}" == "$player" ] && [ "${board[6]}" == "$player" ]; then
        echo "Player $player wins!"
        exit 0
    fi
}

function check_draw() {
    for cell in "${board[@]}"; do
        if [ "$cell" == " " ]; then
            return 1
        fi
    done
    echo "It's a draw!"
    exit 0
}

function make_move() {
    local player=$1
    local position
    read -p "Player $player, enter the position (1-9): " position

    while true; do
        case $position in
            q)
                echo "Goodbye!"
                exit 0
                ;;
            s)
                save_game
                echo "Game saved. Continuing..."
                break
                ;;
            [1-9])
                if [ "${board[$((position-1))]}" == " " ]; then
                    board[$((position-1))]="$player"
                    break
                else
                    read -p "Invalid move. Please enter a valid position (1-9): " position
                fi
                ;;
            *)
                read -p "Invalid input. Please enter a valid position (1-9): " position
                ;;
        esac
    done
}

function save_game() {
    for cell in "${board[@]}"; do
        echo -n "$cell"
    done > saved_game.txt
    echo "" >> saved_game.txt  
}

function load_game() {
    if [ -e saved_game.txt ]; then
        saved_state=$(cat saved_game.txt)
        for i in $(seq 0 8); do
            board[$i]=${saved_state:$i:1}
        done
    else
        echo "No saved game found."
        exit 1
    fi
}

if [ -e saved_game.txt ]; then
    echo "1. Continue saved game"
    echo "2. Start a new game"
    read -p "Enter your choice (1 or 2): " choice

    case $choice in
        1)
            load_game
            echo "Loaded saved game."
            ;;
        2)
            echo "Starting a new game..."
            rm saved_game.txt  
            ;;
        *)
            echo "Invalid choice. Starting a new game..."
            rm saved_game.txt  
            ;;
    esac
else
    echo "No saved game found. Starting a new game..."
fi


while true; do
    print_board
    make_move "X"
    check_winner "X"
    check_draw

    print_board
    make_move "O"
    check_winner "O"
    check_draw
done
