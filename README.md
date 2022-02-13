# tables/join
The join utility is used to merge or join (in SQL parlance) two or more J tables.
## Installation
To install as an addon, in a J session:
```j
   install 'github:tikkanz/jjoin'
```
## Usage
```j
   load 'tables/join'
   coinsert 'pjoin'

   NB. Run Tests
   load '~addons/tables/join/test0.ijs'
All tests pass!
   ]A
┌──┬──────┬───┬───┐
│Id│Name  │Age│Sex│
├──┼──────┼───┼───┤
│1 │Alex  │40 │M  │
├──┼──────┼───┼───┤
│2 │Jim   │12 │M  │
├──┼──────┼───┼───┤
│3 │Jerry │19 │F  │
├──┼──────┼───┼───┤
│4 │Brian │42 │M  │
├──┼──────┼───┼───┤
│5 │Frieda│9  │F  │
└──┴──────┴───┴───┘
   ]B
┌──┬──────┬──────────┬─────────┐
│Id│Name  │Job       │Status   │
├──┼──────┼──────────┼─────────┤
│3 │Jerry │Unemployed│Married  │
├──┼──────┼──────────┼─────────┤
│6 │Jan   │CEO       │Married  │
├──┼──────┼──────────┼─────────┤
│5 │Frieda│student   │Single   │
├──┼──────┼──────────┼─────────┤
│1 │Alex  │Waiter    │Separated│
└──┴──────┴──────────┴─────────┘   
   
```
By default the rows/records in the tables are linked by the first column/field. To specify one or more fields to link the tables, list their names as the left argument.

```j
   left join A;<B                 NB. equivalent
   'Id' left join A;<B            NB. equivalent
   ('Id';'Name') left join A;<B   NB. equivalent
┌──┬──────┬───┬───┬──────────┬─────────┐
│Id│Name  │Age│Sex│Job       │Status   │
├──┼──────┼───┼───┼──────────┼─────────┤
│1 │Alex  │40 │M  │Waiter    │Separated│
├──┼──────┼───┼───┼──────────┼─────────┤
│2 │Jim   │12 │M  │          │         │
├──┼──────┼───┼───┼──────────┼─────────┤
│3 │Jerry │19 │F  │Unemployed│Married  │
├──┼──────┼───┼───┼──────────┼─────────┤
│4 │Brian │42 │M  │          │         │
├──┼──────┼───┼───┼──────────┼─────────┤
│5 │Frieda│9  │F  │student   │Single   │
└──┴──────┴───┴───┴──────────┴─────────┘
```

The `join` adverb modifies a verb to its left that determines the kind of join.  

Available verbs are:
  * `inner`: The output contains rows for values of the key that exist in both the first (left) and second (right) arguments to join.
  * `left`: The output contains rows for values of the key that exist in the first (left) argument to join, whether or not that value exists in the second (right) argument.
  * `right`: The output contains rows for values of the key that exist in the second (right) argument to join, whether or not that value exists in the first (left) argument.
  * `outer`: The output contains rows for values of the key that exist in the first (left) or second (right) argument to join.
  
```j
   right join A;<B
┌──┬───┬───┬──────┬──────────┬─────────┐
│Id│Age│Sex│Name  │Job       │Status   │
├──┼───┼───┼──────┼──────────┼─────────┤
│1 │40 │M  │Alex  │Waiter    │Separated│
├──┼───┼───┼──────┼──────────┼─────────┤
│3 │19 │F  │Jerry │Unemployed│Married  │
├──┼───┼───┼──────┼──────────┼─────────┤
│5 │9  │F  │Frieda│student   │Single   │
├──┼───┼───┼──────┼──────────┼─────────┤
│6 │   │   │Jan   │CEO       │Married  │
└──┴───┴───┴──────┴──────────┴─────────┘
   'Id' inner join A;<B
┌──┬──────┬───┬───┬──────────┬─────────┐
│Id│Name  │Age│Sex│Job       │Status   │
├──┼──────┼───┼───┼──────────┼─────────┤
│1 │Alex  │40 │M  │Waiter    │Separated│
├──┼──────┼───┼───┼──────────┼─────────┤
│3 │Jerry │19 │F  │Unemployed│Married  │
├──┼──────┼───┼───┼──────────┼─────────┤
│5 │Frieda│9  │F  │student   │Single   │
└──┴──────┴───┴───┴──────────┴─────────┘
   ('Id';'Name') outer join A;<B
┌──┬──────┬───┬───┬──────────┬─────────┐
│Id│Name  │Age│Sex│Job       │Status   │
├──┼──────┼───┼───┼──────────┼─────────┤
│1 │Alex  │40 │M  │Waiter    │Separated│
├──┼──────┼───┼───┼──────────┼─────────┤
│2 │Jim   │12 │M  │          │         │
├──┼──────┼───┼───┼──────────┼─────────┤
│3 │Jerry │19 │F  │Unemployed│Married  │
├──┼──────┼───┼───┼──────────┼─────────┤
│4 │Brian │42 │M  │          │         │
├──┼──────┼───┼───┼──────────┼─────────┤
│5 │Frieda│9  │F  │student   │Single   │
├──┼──────┼───┼───┼──────────┼─────────┤
│6 │Jan   │   │   │CEO       │Married  │
└──┴──────┴───┴───┴──────────┴─────────┘
```

See the `~addons/tables/join/test0.ijs` script for more examples.

## Contributions welcome
If you find cases where the addon doesn't behave correctly, feel free to create an Issue.
Note that I haven't yet stress tested the addon to see how it performs with larger tables.
If you'd like to improve/simplify/extend the addon, pull requests are welcome.
