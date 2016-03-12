class SiteController < ApplicationController
  def index
    # Find one Board, its Lists and Cards
    @board = Trello::Board.find(ENV["TRELLO_BOARD_ID"])
    @lists = @board.lists
    @cards = @board.cards

    # Filter out cards without labels
    @cards.select { |c| c.card_labels.empty? }

    @lists_count = @lists.size
    @cards_count = @cards.size

    @average_number_of_cards_per_list = (@cards_count / @lists_count.to_f).round(2)

    hash = Hash.new(0)
    @cards.collect(&:list_id).each do |c|
      hash[c] += 1
    end

    @card_min_array = hash.min_by { |id, count| count }
    @card_max_array = hash.max_by { |id, count| count }
    @card_min = @card_min_array.last
    @card_max = @card_max_array.last
    @card_min_column = @lists.select { |l| l.id == @card_min_array.first }.first.name
    @card_max_column = @lists.select { |l| l.id == @card_max_array.first }.first.name

    @number_of_each_label = @cards.collect(&:card_labels).flatten
    @label_hash = Hash.new(0)
    @cards.each do |card|

      # Count & tally card labels
      labels = card.card_labels
      labels.each do |label|
        @label_hash[label["name"]] += 1
      end
    end

    @total_label_minutes = 0
    @total_label_minutes += (@label_hash["10 minutes"] * 10)
    @total_label_minutes += (@label_hash["1 hour"] * 60)
    @total_label_minutes += (@label_hash["1 day+"] * 1440)
    @total_label_minutes += (@label_hash["4 hours"] * 240)

    @total_label_hours = (@total_label_minutes / 60.0).round(2)
    @total_label_work_weeks = (@total_label_hours / 40.0).round(2)
  end
end
