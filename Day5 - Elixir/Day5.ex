# This solution has not been cleaned whatsoever
# It heavily inspired by 
#    https://github.com/ibarakaiev/advent-of-code-2024/blob/main/lib/advent_of_code2024/day5.ex

defmodule AOCDay5 do
    def to_map(lists) do
        Enum.reduce(lists, %{},fn val, rm ->
                v = [Enum.at(val,1)]
                value = AOCDay5.filter_null(v)
                key = Enum.at(val,0)
                oldArr = [Map.get(rm,key)] |> filter_null()
                #IO.puts "Old: #{oldArr}"
                #IO.puts "New: #{value}"
                value = AOCDay5.to_list(value, oldArr)
                Map.put(rm, key, value)
            end
        )
    end
    def to_list(new_arr, old_arr) do
        #IO.puts new_arr
        #IO.puts old_arr
        filtered = Enum.filter(old_arr, & !is_nil(&1))
        filtered ++ new_arr |> List.flatten()
    end
    def filter_null(list) do
        Enum.filter(list, fn 
            nil -> false
            _  -> true
end)
    end
end

file = File.read!("input.txt")# |> Stream.map(&String.trim/1) |> Enum.to_list()

[rules, updates] = String.split(file, "\r\n\r\n", trim: true)
rules =
    rules
    |> String.split("\r\n", trim: true)
    |> Enum.map(&String.split(&1, "|", trim: true))
rulesMap =
    rules |> AOCDay5.to_map()
updatesOrder = String.split(updates, "\r\n", trim: true) |> Enum.map(&String.split(&1, ",", trim: true))
corrects = Enum.filter(updatesOrder, fn order -> 
        Enum.chunk_every(order, 2, 1, :discard) |>
        Enum.reduce_while(true, fn [first, second],acc ->
        #IO.puts val
        case Map.fetch(rulesMap, first) do
            {:ok, value } ->
                if second in value do
                    {:cont, true}
                else 
                    {:halt, false}
                end
            :error -> {:halt, false}
        end
    end)
end)

centers = Enum.reduce(corrects, [],fn (x,new_list) -> 
    center_index = div(length(x), 2)
    val = Enum.at(x,center_index) |> String.to_integer()
    new_list ++ [val]
end)
value = Enum.sum(centers)
IO.puts "Part1 : #{value}"

incorrects =
          Enum.map(updatesOrder -- corrects, fn incorrects ->
            Enum.sort(incorrects, &(&1 not in rulesMap[&2]))
          end)

incorrect_centers = Enum.reduce(incorrects, [],fn (x,new_list) -> 
    center_index = div(length(x), 2)
    val = Enum.at(x,center_index) |> String.to_integer()
    new_list ++ [val]
end)
value = Enum.sum(incorrect_centers)
IO.puts "Part2 : #{value}"