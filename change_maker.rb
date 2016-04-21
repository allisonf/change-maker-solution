class ChangeMaker
  # Returns an array of the least amount of coins required to get to 'amount'
  # **Assumption** Change can always be made - BONUS POINTS - raise an error if
  # change can not be made
  # Params:
  # +amount+:: The amount to make change for
  # +denominations+:: An array containing the denominations that can be used.
  #                   Defaults to standard US coin denominations
  def self.make_change(amount, denominations=[1,5,10,25])
    
    # Sort denominations array from high to low
    sorted_denominations = denominations.sort { |x, y| y <=> x }

    # Call inner recursive function
    make_greedy_change(amount, sorted_denominations)
  end

  def self.make_greedy_change(amount, denominations, change_array=[])

    # Base Case: We're done!
    if amount == 0
      return change_array
    elsif denominations.length == 0
      # Change not possible! Exception...
      raise ChangeError
    elsif amount < denominations[0]
      # Change not possible! Exception...
      if denominations.length == 1
        raise ChangeError
      else
        # Recursive case
        return make_greedy_change(amount, denominations[1..-1], change_array)
      end
    else
      # Recursive case
      num_coins = amount / (denominations[0])
      num_coins.times do |i|
        print i
        change_array << denominations[0]
      end
      amount_made = num_coins * denominations[0]
      return make_greedy_change(amount - amount_made, denominations[1..-1], change_array)
    end
  end

end

class ChangeError < StandardError; end