Bowling Score
=============

![Logo](https://raw.githubusercontent.com/brpandey/bowling-score/master/priv/images/score.jpg)

Given a valid sequence of bowling game frame scores returns the game score
NOTE: Doesn't do any validation of sequence, expects a valid sequence

#### Run iex -S mix in the bowling directory
#### See Examples

### Example 1

```elixir
      # Parens () denote carryovers
      # addition without parens indicate the sum of just the current roll score

      # 1 : 1           : 1
      # 1 : 2           : 1 + 2 => 3
      # 2 : 3           : 3 + 3 => 6
      # 2 : {:spare, 7} : 6 + 7 => 13
      # 3 : 3           : 13 + 3 + (3) => 19
      # 3 : {:spare, 7} : 19 + 7 => 26
      # 4 : 4           : 26 + 4 + (4)=> 34
      # 4 : 4           : 34 + 4 => 38
      # 5 : 2           : 38 + 2 => 40
      # 5 : 2           : 40 + 2 => 42
      # 6 : 2           : 42 + 2 => 44
      # 6 : {:spare, 8} : 44 + 8 => 52
      # 7 : 2           : 52 + 2 + (2) => 56
      # 7 : 1           : 56 + 1 => 57
      # 8 : 1           : 57 + 1 => 58
      # 8 : 1           : 58 + 1 => 59
      # 9 : 1           : 59 + 1 => 60
      # 9 : 5           : 60 + 5 => 65
      # 10 : 4          : 65 + 4 => 69
      # 10 : 2          : 69 + 2 => 71

      sequence = [1,2,3,:spare,3,:spare,4,4,2,2,2,:spare,2,1,1,1,1,5,4,2]
      71 = Bowling.Score.calculate(sequence)
```

### Example 2

```elixir
      # Parens () denote carryovers
      # addition without parens indicate the sum of just the current roll score

      # 1 : 2             : 2
      # 1 : 1             : 2 + 1 => 3
      # 2 : :strike       : 3 + 10 => 13
      # 3 : 4             : 13 + 4 + (4) => 21
      # 3 : {:spare, 6}   : 21 + 6 + (6) => 33
      # 4 : 2             : 33 + 2 + (2) => 37
      # 4 : 4             : 37 + 4  => 41
      # 5 : 4             : 41 + 4 => 45
      # 5 : 2             : 45 + 2 => 47
      # 6 : 2             : 47 + 2 => 49
      # 6 : 7             : 49 + 7 => 56
      # 7 : :strike       : 56 + 10 => 66
      # 8 : 4             : 66 + 4 + (4) => 74
      # 8 : 2             : 74 + 2 + (2) => 78
      # 9 : 3             : 78 + 3 => 81
      # 9 : 1             : 81 + 1 => 82
      # 10 : 4             : 82 + 4 => 86
      # 10 : 2             : 86 + 2 => 88

      sequence = [2,1,:strike,4,:spare,2,4,4,2,2,7,:strike,4,2,3,1,4,2]
      88 = Bowling.Score.calculate(sequence)
```

### Example 3

```elixir
      # Roll 1 : 10    : 10
      # Roll 2 : 10    : 10 + 10 + (10) => 30
      # Roll 3 : 10    : 30 + 10 + (10 + 10) => 60
      # Roll 4 : 10    : 60 + 10 + (10 + 10) => 90
      # Roll 5 : 10    : 90 + 10 + (10 + 10) => 120
      # Roll 6 : 10    : 120 + 10 + (10 + 10) => 150
      # Roll 7 : 10    : 150 + 10 + (10 + 10) => 180
      # Roll 8 : 10    : 180 + 10 + (10 + 10) => 210
      # Roll 9 : 10    : 210 + 10 + (10 + 10) => 240
      # Roll 10 : 10   : 240 + 10 + (10 + 10) => 270
      # Roll 11 : 10   : 270 + 10 + (10) => 290    ### Roll 9's carryover is added in Roll 11
      # Roll 12 : 10   : 290 + 10 => 300

      # Frame 1 : 10 + (Roll 2 Strike + Roll 3 Strike)
      # Frame 2 : 10 + (Roll 3 Strike + Roll 4 Strike)
      # Frame 3 : 10 + (Roll 4 Strike + Roll 5 Strike)
      # Frame 4 : 10 + (Roll 5 Strike + Roll 6 Strike)
      # Frame 5 : 10 + (Roll 6 Strike + Roll 7 Strike)
      # Frame 6 : 10 + (Roll 7 Strike + Roll 8 Strike)
      # Frame 7 : 10 + (Roll 8 Strike + Roll 9 Strike)
      # Frame 8 : 10 + (Roll 9 Strike + Roll 10 Strike)
      # Frame 9 : 10 + (Roll 10 Strike + Roll 11 Strike)
      # Frame 10 : 10 + (10 + 10)                            : 



      # 10 Frames * (10 + 10 + 10) = 10 * 30 = 300

      sequence = [:strike,:strike,:strike,:strike,:strike,:strike,:strike,:strike,:strike,:strike,:strike,:strike]
      300 = Bowling.Score.calculate(sequence)
```

### Example 4

```elixir
      # 1 : 5             : 5
      # 1 : {:spare, 5}   : 5 + 5 => 10
      # 2 : 5             : 10 + 5 + (5) => 20
      # 2 : {:spare, 5}   : 20 + 5 => 25
      # 3 : 5             : 25 + 5 + (5) => 35
      # 3 : {:spare, 5}   : 35 + 5 => 40
      # 4 : 5             : 40 + 5 + (5) => 50
      # 4 : {:spare, 5}   : 50 + 5 => 55
      # 5 : 5             : 55 + 5 + (5) => 65
      # 5 : {:spare, 5}   : 65 + 5 => 70
      # 6 : 5             : 70 + 5 + (5) => 80
      # 6 : {:spare, 5}   : 80 + 5 => 85
      # 7 : 5             : 85 + 5 + (5) => 95
      # 7 : {:spare, 5}   : 95 + 5 => 100
      # 8 : 5             : 100 + 5 + (5) => 110
      # 8 : {:spare, 5}   : 110 + 5 => 115
      # 9 : 5             : 115 + 5 + (5) => 125
      # 9 : {:spare, 5}   : 125 + 5 => 130
      # 10 : 5            : 130 + 5 + (5) => 140
      # 10 : {:spare, 5}  : 140 + 5 => 145
      # 10 : 5            : 145 + 5 => 150 # last frame we don't add spare carryover

      sequence = [5,:spare,5,:spare,5,:spare,5,:spare,5,:spare,5,:spare,5,:spare,5,:spare,5,:spare,5,:spare,5]
      150 = Bowling.Score.calculate(sequence)
```




Bowling is COOL! And Learning how the game is scored FINALLY makes sense!! 

** Thanks, Bibek **