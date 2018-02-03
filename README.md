# join
This utility is used to merge or join (in SQL parlance) two or more J tables. 
```j
require 'tables/csv'
A=: fixcsv noun define
Id,Name,Age,Sex
1,Alex,40,M
2,Jim,12,M
3,Jerry,19,F
)

B=: fixcsv noun define
Id,Name,Job,Status
6,Jan,CEO,Married
1,Alex,Waiter,Separated
)
```
By default the rows/records in the tables are linked by the first column/field. To specify one or more fields to link the tables, list their names as the left argument.

```j
   left join A;<B                 NB. equivalent
   'Id' left join A;<B            NB. equivalent
   ('Id';'Name') left join A;<B   NB. equivalent
┌──┬─────┬───┬───┬──────┬─────────┐
│Id│Name │Age│Sex│Job   │Status   │
├──┼─────┼───┼───┼──────┼─────────┤
│1 │Alex │40 │M  │Waiter│Separated│
├──┼─────┼───┼───┼──────┼─────────┤
│2 │Jim  │12 │M  │      │         │
├──┼─────┼───┼───┼──────┼─────────┤
│3 │Jerry│19 │F  │      │         │
└──┴─────┴───┴───┴──────┴─────────┘
```

The `join` adverb modifies a verb to its left that determines the kind of join.  

Available verbs are:
  * `inner`: The output contains rows for values of the key that exist in both the first (left) and second (right) arguments to join.
  * `left`: The output contains rows for values of the key that exist in the first (left) argument to join, whether or not that value exists in the second (right) argument.
  * `right`: The output contains rows for values of the key that exist in the second (right) argument to join, whether or not that value exists in the first (left) argument.
  * `outer`: The output contains rows for values of the key that exist in the first (left) or second (right) argument to join.
  
```j
   right join A;<B
┌──┬───┬───┬────┬──────┬─────────┐
│Id│Age│Sex│Name│Job   │Status   │
├──┼───┼───┼────┼──────┼─────────┤
│6 │   │   │Jan │CEO   │Married  │
├──┼───┼───┼────┼──────┼─────────┤
│1 │40 │M  │Alex│Waiter│Separated│
└──┴───┴───┴────┴──────┴─────────┘
   'Id' inner join A;<B
┌──┬────┬───┬───┬──────┬─────────┐
│Id│Name│Age│Sex│Job   │Status   │
├──┼────┼───┼───┼──────┼─────────┤
│1 │Alex│40 │M  │Waiter│Separated│
└──┴────┴───┴───┴──────┴─────────┘
   ('Id';'Name') outer join A;<B
┌──┬─────┬───┬───┬──────┬─────────┐
│Id│Name │Age│Sex│Job   │Status   │
├──┼─────┼───┼───┼──────┼─────────┤
│1 │Alex │40 │M  │Waiter│Separated│
├──┼─────┼───┼───┼──────┼─────────┤
│2 │Jim  │12 │M  │      │         │
├──┼─────┼───┼───┼──────┼─────────┤
│3 │Jerry│19 │F  │      │         │
├──┼─────┼───┼───┼──────┼─────────┤
│6 │Jan  │   │   │CEO   │Married  │
└──┴─────┴───┴───┴──────┴─────────┘
```
