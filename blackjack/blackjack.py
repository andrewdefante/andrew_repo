# python allows you to import packages
# allows you to use specific functions that are applicable to the task 
# you are doing 
# ex) beautifulsoup <- web scraping, ggplot <- making graphs

import random 


## create a deck of cards

# define suits, ranks, values
suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
ranks = ['Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Jack', 'Queen', 'King', 'Ace']
values = {'Two': 2, 'Three': 3, 'Four': 4, 'Five': 5, 'Six': 6, 'Seven': 7, 'Eight': 8, 'Nine': 9, 'Ten': 10, 'Jack': 10, 'Queen': 10, 'King': 10, 'Ace': 11}


playing = True

## classes = ideal when each level has specific attributes, each card has a value
    # blueprint for creating instances
## instance of class = each level created in class
    # __init__ - initialize, constructor
        # __init__ ('instance_name', argument to accept 1, argument to accept 2)
        
## Create Cards
class Card(object):
    
    def __init__(self, suit, rank):
        self.suit = suit
        self.rank = rank
    
    def __str__(self):
        return self.rank + ' of ' + self.suit 

## Create Deck
class Deck(object):
    
    def __init__(self):
        self.cards = [] ## list
        self.build()
    
    def build(self):
        for suit in suits:
            for rank in ranks:
                    self.cards.append(Card(suit, rank))
    
    def show(self):
        for c in self.cards:
            c.show()
    
    def shuffle(self):
        random.shuffle(self.cards)
    
    def deal(self):
        return self.cards.pop()

## Create Hand
class Hand(object):
    
    def __init__(self):
        self.cards = []
        self.value = 0
        self.aces = 0 
    
    def add_card(self, card):
        self.cards.append(card)
        self.value += values[card.rank]
        if card.rank == 'Ace':
            self.aces += 1
    
    def adjust_ace(self):
        while self.value > 21 and self.aces:
            self.value -= 10 
            self.aces -= 1 

## Create Chips 
class Chips(object):
    def __init__(self):
        self.total = 100
        self.bet = 0
    
    def win_bet(self):
        self.total += self.bet # (self.total + self.bet)

    def lose_bet(self):
        self.total -= self.bet # (self.total - self.bet)

## Functions

# ask for standard bet from user
def place_bet(chips):
    
    while True:
        try:
            chips.bet = int(input("How many chips would you like to bet?"))
        except ValueError:
            print("Please enter a valid number")
        else:
            if chips.bet > chips.total:
                print("You do not have enough chips")
            else: 
                break

# define hit
def hit(deck, hand):
    hand.add_card(deck.deal())
    hand.adjust_ace()

# function that asks player what they want to do
def hit_or_stay(deck, hand):
    global playing

    while True:
        ask = input("\nWould you like to hit or stay? Type 'h' or 's': ")

        if ask[0].lower() == 'h':
            hit(deck, hand)
        elif ask[0].lower() == 's':
            print("Player stays, Dealer is playing.")
            playing = False
        else:
            print("Please try again!")
            continue
        break

# function that shows hands
def show_some(player, dealer):
    print("\nDealer's Hand: ")
    print(" <card hidden>")
    print("", dealer.cards[1])
    print("\nPlayer's Hand: ", *player.cards, sep='\n ')


def show_all(player, dealer):
    print("\nDealer's Hand: ", *dealer.cards, sep='\n ')
    print("Dealer's Hand =", dealer.value)
    print("\nPlayer's Hand: ", *player.cards, sep='\n ')
    print("Player's Hand =", player.value)

## Functions for Ending Scenarios
# game endings

def player_busts(player, dealer, chips):
    print("You Lose, Player Bust")
    chips.lose_bet()


def player_wins(player, dealer, chips):
    print("You Win!")
    chips.win_bet()


def dealer_busts(player, dealer, chips):
    print("You Win! Dealer Bust")
    chips.win_bet()


def dealer_wins(player, dealer, chips):
    print("You Lose, Dealer Wins")
    chips.lose_bet()


def push(player, dealer):
    print("Push")


# Play

while True:
    print("You are playing black jack")

    # create and shuffle deck
    deck = Deck()
    deck.shuffle()

    # deal cards to create hands
    player_hand = Hand()
    player_hand.add_card(deck.deal())
    player_hand.add_card(deck.deal())

    dealer_hand = Hand()
    dealer_hand.add_card(deck.deal())
    dealer_hand.add_card(deck.deal())

    # set up the player's chips
    player_chips = Chips()

    # player places bet
    place_bet(player_chips)

    # show cards
    show_some(player_hand, dealer_hand)

    while playing:

        hit_or_stay(deck, player_hand)
        show_some(player_hand, dealer_hand)

        if player_hand.value > 21:
            player_busts(player_hand, dealer_hand, player_chips)
            break

    if player_hand.value <= 21:

        while dealer_hand.value < 17:
            hit(deck, dealer_hand)

        show_all(player_hand, dealer_hand)

        if dealer_hand.value > 21:
            dealer_busts(player_hand, dealer_hand, player_chips)

        elif dealer_hand.value > player_hand.value:
            dealer_wins(player_hand, dealer_hand, player_chips)

        elif dealer_hand.value < player_hand.value:
            player_wins(player_hand, dealer_hand, player_chips)

        if player_hand.value > 21:
            player_busts(player_hand, dealer_hand, player_chips)

    print("\nPlayer's winnings stand at", player_chips.total)

    new_game = input("\nWould you like to play again? Enter 'y' or 'n': ")
    if new_game[0].lower() == 'y':
        playing = True
        continue
    else:
        print("\nThanks for playing!")
        break

    print("\n Player winnings stand at:", player_chips.total)

    new_game = input("Would you like to play again? Enter 'y' or 'n':")
    if new_game[0].lower() == 'y':
        playing = True
        continue
    else:
        break 

    # defining outcomes
    while playing:

        hit_or_stay(deck, player_hand)
        show_some(player_hand, dealer_hand)

        if player_hand.value > 21:
            player_busts(player_hand, dealer_hand, player_chips)
            break

        show_all(player_hand, dealer_hand)

        if dealer_hand.value > 21:
            dealer_busts(player_hand, dealer_hand, player_chips)

        if player_hand.value > dealer_hand.value
        


    new_game = input("\n Would you like to play again?")
    if new_game[0].lower() == 'y':
        playing = True
        continue
    else:
        print("exiting game")
        break