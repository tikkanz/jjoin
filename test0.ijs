coinsert 'pjoin'
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

patients=: fixcsv {{)n
PATIENTID,LASTNAME
1001,Hopper
4004,Wirth
3003,Kemeny
2002,Gosling
5005,Kurtz
}}
 
visits=: fixcsv {{)n
PATIENTID,VISIT_DATE,SCORE
2002,2020-09-10,6.8
1001,2020-09-17,5.5
4004,2020-09-24,8.4
2002,2020-10-08,
1001,,6.6
3003,2020-11-12,
4004,2020-11-05,7.0
1001,2020-11-19,5.3
}}

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

LeftPV=: fixcsv noun define
PATIENTID,LASTNAME,VISIT_DATE,SCORE
2002,Gosling,2020-09-10,6.8
1001,Hopper,2020-09-17,5.5
4004,Wirth,2020-09-24,8.4
2002,Gosling,2020-10-08,
1001,Hopper,,6.6
3003,Kemeny,2020-11-12,
4004,Wirth,2020-11-05,7.0
1001,Hopper,2020-11-19,5.3
5005,Kurtz,,
)

InnerPV=: fixcsv noun define
PATIENTID,LASTNAME,VISIT_DATE,SCORE
2002,Gosling,2020-09-10,6.8
1001,Hopper,2020-09-17,5.5
4004,Wirth,2020-09-24,8.4
2002,Gosling,2020-10-08,
1001,Hopper,,6.6
3003,Kemeny,2020-11-12,
4004,Wirth,2020-11-05,7.0
1001,Hopper,2020-11-19,5.3
)

OuterPV=: fixcsv noun define
PATIENTID,LASTNAME,VISIT_DATE,SCORE
2002,Gosling,2020-09-10,6.8
1001,Hopper,2020-09-17,5.5
4004,Wirth,2020-09-24,8.4
2002,Gosling,2020-10-08,
1001,Hopper,,6.6
3003,Kemeny,2020-11-12,
4004,Wirth,2020-11-05,7.0
1001,Hopper,2020-11-19,5.3
5005,Kurtz,,
)

RightPV=: fixcsv noun define
PATIENTID,LASTNAME,VISIT_DATE,SCORE
2002,Gosling,2020-09-10,6.8
1001,Hopper,2020-09-17,5.5
4004,Wirth,2020-09-24,8.4
2002,Gosling,2020-10-08,
1001,Hopper,,6.6
3003,Kemeny,2020-11-12,
4004,Wirth,2020-11-05,7.0
1001,Hopper,2020-11-19,5.3
)

AN=: 0 ". ];._2 noun define
3  0.038 56
8  0.335  6
6  0.058 48
4  0.691 96
5  0.770 59
1  0.416 72
7  0.246  1
)

BN=: 0 ". ];._2 noun define
2  0.033  6 908
6  0.985 35 148
7  0.619 46  76
4  0.001 33 672
)

Inner_ANBN=: 0 ". ];._2 noun define
6 0.058 48 0.985 35 148
4 0.691 96 0.001 33 672
7 0.246  1 0.619 46  76
)

Right_ANBN=: 0 ". ];._2 noun define
2 _9999 _9999 0.033  6 908
6 0.058    48 0.985 35 148
7 0.246     1 0.619 46  76
4 0.691    96 0.001 33 672
)

sortTable=: {. , sort@}.

test=: verb define
  assert. LeftAB -: left join A;<B
  assert. RightAB -:&sortTable right join A;<B
  assert. InnerAB -: inner join A;<B
  assert. OuterAB -: outer join A;<B 
  assert. LeftBA -: left join B;<A
  assert. LeftABC -: 'Id' left join A;B;<C
  assert. LeftPV -: left join patients ;< visits
  assert. InnerPV -: inner join patients ;< visits
  assert. OuterPV -: outer join patients ;< visits
  assert. RightPV -:&sortTable right join patients ;< visits
  assert. Inner_ANBN -: inner join1st AN;<BN
  assert. Right_ANBN -: 0 right join1st AN;<BN
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

Note 'simple merge no header'
a=:(<"0 i. 4),.(<'x')
b=:_2]\(1;'a';2;'b';10;'c')
c=:_3]\0;'x';'';1;'x';'a';2;'x';'b';3;'x';''

leftJoin=: [ ,. i.~&:({."1) { a: ,~ }."1@]

c-: (a leftJoin b)
)
