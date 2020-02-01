# Create an expression that solves the following problem: Sarah has bought ten slices of bread for ten cents each, three bottles of milk for two dollars each, and a cake for fifteen dollars. How many dollars has Sarah spent?

total_cost = (10 * 0.1) + (3 * 2) + (1 * 15)
IO.puts(total_cost)

# Bob has traveled 200 km in four hours. Using variables, print a message showing his travel distance, time, and average velocity.

name = "Bob"
distance = 200.0
time = 4
velocity = distance / time

IO.puts("#{name} traveled #{distance} km in #{time} hours at an average velocity of #{velocity} km/hr.")

# Build an anonymous function that applies a tax of 12% to a given price. It should print a message with the new price and tax value. Bind the anonymous function to a variable called apply_tax. You should use apply_tax with Enum.each/2, like in the following example. Don’t worry about Enum.each/2 now; you’ll see it in detail in Chapter 5, Using Higher-Order Functions. You only need to know that Enum.each/2 will execute apply_tax in each item of a list.

# Enum.each [12.5, 30.99, 250.49, 18.80], apply_tax
# Price: 14.0 - Tax: 1.5
# Price: 34.7088 - Tax: 3.7188
# Price: 280.5488 - Tax: 30.0588
# Price: 21.056 - Tax: 2.256

apply_tax = fn
  untaxed -> tax = untaxed * 0.12; total = untaxed + tax; IO.puts("Price: #{total} - Tax: #{tax}")
end

Enum.each [12.5, 30.99, 250.49, 18.80], apply_tax


# Create a module called MatchstickFactory and a function called boxes/1. The function will calculate the number of boxes necessary to accommodate some matchsticks. It returns a map with the number of boxes necessary for each type of box. The factory has three types of boxes: the big ones hold fifty matchsticks, the medium ones hold twenty, and the small ones hold five. The boxes can’t have fewer matchstick that they can hold; they must be full. The returning map should contain the remaining matchsticks. It should work like this:
# MatchstickFactory.boxes(98)
# # %{big: 1, medium: 2, remaining_matchsticks: 3, small: 1}
# MatchstickFactory.boxes(39)
# %{big: 0, medium: 1, remaining_matchsticks: 4, small: 3}

# Tip: You’ll need to use the rem/2 and div/2 functions.[13]

defmodule MatchstickFactory do
  def boxes(matchsticks) do
    [big, remaining] = box(matchsticks, 50)
    [medium, remaining] = box(remaining, 20)
    [small, remaining] = box(remaining, 5)

    output = %{big: big, medium: medium, small: small, remaining_matchsticks: remaining}
    IO.inspect(output)
  end

  def box(matchsticks, box_size) do
    boxed = div(matchsticks, box_size)
    remaining = matchsticks - (box_size * boxed)
    [boxed, remaining]
  end
end

MatchstickFactory.boxes(98)
MatchstickFactory.boxes(39)

defmodule Factory do
  def boxes(matchsticks) do
    output = %{remaining_matchsticks: matchsticks}
             |> box(:big, 50)
             |> box(:medium, 20)
             |> box(:small, 5)

    IO.inspect(output)
  end

  def box(boxed, key, denominator) do
    new_box = %{key => div(boxed.remaining_matchsticks, denominator)}
    rem = boxed[:remaining_matchsticks] - (denominator * new_box[key])
    boxed = Map.put(boxed, :remaining_matchsticks, rem)
    Map.merge(boxed, new_box)
  end
end

Factory.boxes(98)
Factory.boxes(39)



defmodule RecursiveFactory do
  def boxes(
    remaining_matchsticks,
    output \\ %{},
    box_sizes \\ [[:big, 50], [:medium, 20], [:small, 5]],
    index \\ 0
  ) do
    case box_sizes do
      [] ->
        IO.inspect(output)
      _x ->
        [current_size | remaining_sizes] = box_sizes
        key = List.first(current_size)
        value = List.last(current_size)

        new_box = %{key => div(remaining_matchsticks, value)}
        rem = remaining_matchsticks - (value * new_box[key])
        boxed = Map.put(output, :remaining_matchsticks, rem)
        output = Map.merge(boxed, new_box)
        index = index + 1

        RecursiveFactory.boxes(rem, output, remaining_sizes, index)
    end
  end
end

RecursiveFactory.boxes(98)
RecursiveFactory.boxes(39)
