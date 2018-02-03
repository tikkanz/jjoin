
require 'tables/csv'

A=: fixcsv noun define
Id,Name,Age,Sex
1,Alex,40,M
2,Jim,12,M
3,Jerry,19,F
4,Brian,42,M
5,Frieda,9,F
)

B=: fixcsv noun define
Id,Name,Job,Status
3,Jerry,Unemployed,Married
6,Jan,CEO,Married
5,Frieda,student,Single
1,Alex,Waiter,Separated
)

C=: fixcsv noun define
Id,Bank,Name,Kids
3,Rabobank,Jerry,2
6,HSBC,Jan,0
4,Westpac,Brian,1
1,HSBC,Alex,2
7,,Ben,0
)

LeftAB=: fixcsv noun define
Id,Name,Age,Sex,Job,Status
1,Alex,40,M,Waiter,Separated
2,Jim,12,M,,
3,Jerry,19,F,Unemployed,Married
4,Brian,42,M,,
5,Frieda,9,F,student,Single
)

RightAB=: fixcsv noun define
Id,Age,Sex,Name,Job,Status
3,19,F,Jerry,Unemployed,Married
6,,,Jan,CEO,Married
5,9,F,Frieda,student,Single
1,40,M,Alex,Waiter,Separated
)

InnerAB=: fixcsv noun define
Id,Name,Age,Sex,Job,Status
1,Alex,40,M,Waiter,Separated
3,Jerry,19,F,Unemployed,Married
5,Frieda,9,F,student,Single
)

OuterAB=: fixcsv noun define
Id,Name,Age,Sex,Job,Status
1,Alex,40,M,Waiter,Separated
2,Jim,12,M,,
3,Jerry,19,F,Unemployed,Married
4,Brian,42,M,,
5,Frieda,9,F,student,Single
6,,,,CEO,Married
)

LeftBA=: fixcsv noun define
Id,Name,Job,Status,Age,Sex
3,Jerry,Unemployed,Married,19,F
6,Jan,CEO,Married,,
5,Frieda,student,Single,9,F
1,Alex,Waiter,Separated,40,M
)

LeftABC=: fixcsv noun define
Id,Name,Age,Sex,Job,Status,Bank,Kids
1,Alex,40,M,Waiter,Separated,HSBC,2
2,Jim,12,M,,,,
3,Jerry,19,F,Unemployed,Married,Rabobank,2
4,Brian,42,M,,,Westpac,1
5,Frieda,9,F,student,Single,,
)

test=: verb define
  assert. LeftAB -: left join A;<B
  assert. RightAB -: right join A;<B
  assert. InnerAB -: inner join A;<B
  assert. OuterAB -: outer join A;<B 
  assert. LeftBA -: left join B;<A
  assert. LeftABC -: 'Id' left join A;B;<C
  'All tests pass!'
)

echo test ''

Note 'example usage'
'Id' left join A;<B
('Id';'Name') left join A;<B
('Id';'Name') left join A;B;<C
('Id';'Name') right join A;B;<C
outer join A;B;<C
)

Note 'example usage'
A 'Id' merge left B
A ('Id';'Name') merge left B
A ('Id';'Name') merge right B
A 'Id' merge outer B
)

Note 'simple merge no header'
a=:(<"0 i. 4),.(<'x')
b=:_2]\(1;'a';2;'b';10;'c')
c=:_3]\0;'x';'';1;'x';'a';2;'x';'b';3;'x';''

leftJoin=: [ ,. i.~&:({."1) { a: ,~ }."1@]


c-: (a leftJoin b)
1

NB. Ric Sherlock's implementation from yesterday [1]
joinLeft=: [ , ] #~ e.~&:({."1)
summary=: (~.@:({."1) ,. {."1 ]/. {:"1)

c-: (a summary at joinLeft b)
1

a=:(<"0 i. 1e6),.(<'x')
b=:_2]\(999997;1;999999;2)

timespacex 'c1=:a summary at joinLeft b'
1.28482 1.16477e8

timespacex 'c2=:a leftJoin b'
0.627465 6.65212e7


c1 -: c2
)
