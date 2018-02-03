defmodule Bowling.Score do
  @moduledoc """
  Given a valid list of bowling frame scores returns
  the game score. Does not determine validity of sequences

  For example here is a valid sequence list:
  [2,1,:strike,4,:spare,2,4,4,2,2,7,:strike,4,2,3,:dash,4,2]
  """

  @strike 10
  @frames 10
  @dash 0

  # Scan through list for :spare or :dash entries,
  # convert :spare into {:spare, remaining_frame_pins}
  defp preprocess(list) when is_list(list) do
    {_, reversed_list} =
      Enum.reduce(list, {nil, []}, fn roll, {prev, list_acc} ->
        # if spare, create a tuple with spare and remaining pins knocked down
        # if dash, convert to score of 0 for a roll
        # otherwise, just pass the value of the roll as the value

        updated =
          case roll do
            :spare -> {:spare, @strike - prev}
            :dash -> @dash
            _ -> roll
          end

        # prepend to new list
        # prepend is O(1)
        new_list = [updated | list_acc]

        # set the updated val as the new prev
        {updated, new_list}
      end)

    Enum.reverse(reversed_list)
  end

  # Retrieve the proper value given the list entry
  defp value(:strike), do: @strike
  defp value({:spare, i}) when is_integer(i), do: i
  defp value(i), do: i

  # If we have a strike following a strike, we need to chain them together appropriately
  # NOTE: A spare doesn't follow a strike directly, there's always a roll before the spare roll 
  # NOTE: If we have a spare following a spare, there's no overlap
  defp chain(:strike, :no_carryover), do: :add_next_first_second_roll
  defp chain(:strike, :add_next_first_roll), do: :add_next_double_first_second_roll
  defp chain(:spare, :no_carryover), do: :add_next_first_roll

  # Combine any carryovers that have been set thus far
  # Also ensures the carryover state is correct if we have back to back strikes
  defp handle_carryover(total_score, roll_entry, carryover_flag)
       when (is_integer(roll_entry) or is_atom(roll_entry) or is_tuple(roll_entry)) and
              is_integer(total_score) and is_atom(carryover_flag) do
    r = roll_entry
    t = total_score

    case carryover_flag do
      :add_next_double_first_second_roll -> {t + 2 * value(r), :add_next_first_roll}
      :add_next_first_second_roll -> {t + value(r), :add_next_first_roll}
      :add_next_first_roll -> {t + value(r), :no_carryover}
      :no_carryover -> {t, :no_carryover}
    end
  end

  @doc """
  Calculate's bowling game scores by functionally walking through score list

  Does not perform any lookaheads to compute strike and spare scores but instead
  sets up the proper carryover flag state to track when to add the carryovers

  Computes score by adding the current roll's score and the appropriate carryover value(s)
  """
  def calculate(list) when is_list(list) do
    # preprocess list so that we can put spare information in proper form
    l = preprocess(list)

    # reduce preprocessed list, with roll number n equal to 1, 0 total score, and
    # no carryover flags set initially
    {_, score, _} =
      Enum.reduce(l, {1, 0, :no_carryover}, fn val, {n, score_acc, flag_acc} ->
        # Process carryovers
        {score_acc, flag_acc} = handle_carryover(score_acc, val, flag_acc)

        cond do
          # If we are on the last game frame (e.g. greater than roll 18)
          # just add up the roll scores with no new carryovers, meaning no chaining
          n > (@frames - 1) * 2 ->
            {n, score_acc + value(val), flag_acc}

          # Otherwise process all frame rolls taking into account chaining
          true ->
            case val do
              # For strike, increment up 2 rolls, add the strike 10 and then
              # chain to handle back to back strikes
              :strike ->
                {n + 2, score_acc + @strike, chain(:strike, flag_acc)}

              # For spare, increment up 1 roll, add the remaining pins value,
              # then chain
              {:spare, rem} ->
                {n + 1, score_acc + rem, chain(:spare, flag_acc)}

              # For every integer value just sum up
              val when is_integer(val) ->
                {n + 1, score_acc + val, flag_acc}
            end
        end
      end)

    score
  end
end
