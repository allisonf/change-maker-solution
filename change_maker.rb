class ChangeMaker
  # Returns an array of the least amount of coins required to get to 'amount'
  # **Assumption** Change can always be made - BONUS POINTS - raise an error if
  # change can not be made
  # Params:
  # +amount+:: The amount to make change for
  # +denominations+:: An array containing the denominations that can be used.
  #                   Defaults to standard US coin denominations
  def self.make_greedy_change(amount, denominations=[1,5,10,25])
    
    # Sort denominations array from high to low
    sorted_denominations = denominations.sort { |x, y| y <=> x }

    # Call inner recursive function
    greedy_recurse(amount, sorted_denominations)
  end

  def self.greedy_recurse(amount, denominations, change_array=[])

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
        return greedy_recurse(amount, denominations[1..-1], change_array)
      end
    else
      # Recursive case
      #num_coins = amount / (denominations[0])
      #num_coins.times do |i|
      ##  change_array << denominations[0]
      #end
      #amount_made = num_coins * denominations[0]
      result = add_to_change_array(amount, denominations[0], change_array)

      return greedy_recurse(amount - result[:amount_made], denominations[1..-1], result[:change_array])
    end
  end

  # Helper method to add the max number of new coins that can fit to the change_array
  def self.add_to_change_array(amount, denomination, change_array)

    change_array_out = change_array.dup

    num_coins = amount / denomination
    num_coins.times do |i|
      change_array_out << denomination
    end
    amount_made = num_coins * denomination

    return {:amount_made => amount_made, :change_array => change_array_out}
  end

  # Helper method return the shorter array
  def self.min_by_length(a, b)
    if a.length < b.length
      return a
    else
      return b
    end
  end

  # Helper method to determine whether a change_array adds up to amount
  def self.is_valid_change(amount, change_array)
    
    if change_array == nil
      return false
    end

    amount_made = change_array.reduce(0) { |sum, n| sum + n}

    if amount_made != amount
      return false
    else
      return true
    end

  end

  # Returns an array of the least amount of coins required to get to 'amount'
  # **Assumption** Change can always be made - BONUS POINTS - raise an error if
  # change can not be made
  # Params:
  # +amount+:: The amount to make change for
  # +denominations+:: An array containing the denominations that can be used.
  #                   Defaults to standard US coin denominations
  def self.make_patient_change(amount, denominations=[1,5,10,25])

    # Sort denominations array from high to low
    sorted_denominations = denominations.sort { |x, y| y <=> x }

    # Call inner recursive function
    change_array = patient_recurse(amount, amount, sorted_denominations)

    if is_valid_change(amount, change_array)
      return change_array
    else
      raise ChangeError
    end
  end

  # Not tail recursive!
  def self.patient_recurse(total_amount, recursive_amount, denominations, change_array=[])

    if recursive_amount < 0
      # base case
      return nil
    elsif recursive_amount == 0
      # base case
      return change_array
    elsif denominations.length == 0
      # base case
      return nil
    elsif denominations.length == 1
      # recurse!
      # If there's only one denomination left, we don't need to do our 
      # patient look-ahead step
      result = add_to_change_array(recursive_amount, denominations[0], change_array)
      return patient_recurse(total_amount, recursive_amount - result[:amount_made], denominations[1..-1], result[:change_array])
    else
      # recurse!
      # Count how many of each coin left could be added to the change array
      results = denominations.map { |d| add_to_change_array(recursive_amount, d, change_array)}
      # do a recursive call once for each element in denominations!!!
      # This is our "patient look-ahead" for an shorter solution
      # recursing on the first denomination in the list is greedy
      change_arrays = results.each_with_index.map { |r, i| patient_recurse(total_amount, recursive_amount - r[:amount_made], denominations[(i+1)..-1], r[:change_array])}

      # Determine just the valid arrays
      valid_change_arrays = change_arrays.select { |change_array| is_valid_change(total_amount, change_array)}
      
      # return shortest valid change array
      if valid_change_arrays.length == 0
        return nil
      else
        return valid_change_arrays.reduce { |min, i| min_by_length(min, i)}
      end
    end
    
  end

  private_class_method :add_to_change_array, :min_by_length, :is_valid_change

end


class ChangeError < StandardError; end