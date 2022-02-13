NB.=========================================================
NB. Joining/Merging tables

require 'tables/csv'
cocurrent 'pjoin'

NB. Set operations on lists
intersect=: [ -. -.   NB. items common to both x and y (in order of left appearence)
intersectright=: ] -. -.~ NB. items common to both x and y (in order of right appearence)
union=: ,             NB. items from both x and y
NB. left=: leftonly ,~ [ #~ e.        NB. items of x and y that occur in x
NB. right=: left~         NB. items of x and y that occur in y
left=: [
right=: ]
inner=: intersect  NB. items of x and y that occur in both x and y
outer=: union         NB. items of x and y that occur in either x or y
outer=: (] {~ [: <@<@< #@] -.~ i.~) ,~ left
leftonly=: -. -. ]    NB. items that occur only in x
rightonly=: -. -. [   NB. items that occur only in y

isnumeric=: 3!:0 e. 1 4 8 16 64 128"_
hasDups=: -.@(-: ~.)               NB. contains duplicate items

oc=: i.~ (] - {) /:@/:             NB. occurrence count
pi=: #@[ ({. i.&(,.oc) }.) [ i. ,  NB. progressive index of

isNumericField=: monad define
  if. isnumeric y do. return. 1 end.
  if. 'boxed' -: datatype y do.
     0.3 < (+/ % #) isnumeric &> makenum y
  end.
)

left=: 'left'
right=: 'right'
outer=: 'outer'
inner=: 'inner'

Note 'plan'
Build an ugly but hopefully correct implementation to start from.
Use select case to model the different join opitions independently to start with.
Once correct with good tests, then look to find similarities and refactor.
Do I need to check/specify table relationship (1-to-1 vs 1-to-many) and change merge behaviour accordingly?
)

NB.*join a Join tables y on key columns x using join strategy u
NB. eg: (<'Id') left join A;<B
NB. form: x u join y
NB. x is: list of of key labels (optional, default is first field)
NB. y is: list of boxed tables to merge
NB. u is: verb strategy for joining table indicies (left, right, inner, outer)
join=: adverb define
  key=. {.{. >@{. y                                     NB. default key is first field
  key u join y
:
  key=. boxopen x
  if. (right`'') = (u`'') do.  NB. handle when left & right have non-key fields in common
    jhdr=. key , key -.~ ~. &.|. ; {.&.> y                  NB. header in joined
    cidx=. (] i.&.> [: }. [: -.~&.>/\ key ; ])&.|. {.&.> y  NB. add uniq cols progressively from left
  else.
    jhdr=. key , key -.~ ~. ; {.&.> y                       NB. header in joined
    cidx=. (] i.&.> [: }. [: -.~&.>/\ key ; ]) {.&.> y      NB. add uniq cols progressively from left
  end.
  jkey=. ~.; u&.>/ ((key i.~ {.) {"1 }.)&.> y               NB. key cols in joined
  ridx=. (jkey i.~ }. {"1~ key i.~ {.)&.> y
  jdat=. ;,.&.>/ (ridx <@;&.> cidx) ([ { a: ,~ }.@]) &.> y  NB. data cols in joined
  jhdr , jkey ,. jdat
)

NB.*join a Join tables y on key columns x using join strategy m
NB. ugly but correct rewrite
join=: adverb define
  key=. {.{. >@{. y                                     NB. default key is first field
  key m join y
:
  key=. boxopen x
  if. 'right' -: m do.  NB. handle when left & right have non-key fields in common
    jhdr=. key , key -.~ ~. &.|. ; {.&.> y               NB. header for joined tables
    colidx=. (] i.&.> [: }. [: -.~&.>/\ key ; ])&.|. {.&.> y NB. consolidate indicies of uniq (non-key) cols in each table progressively from right
  else.
    jhdr=. key , key -.~ ~. ; {.&.> y                    NB. header for joined tables
    colidx=. (] i.&.> [: }. [: -.~&.>/\ key ; ]) {.&.> y NB. consolidate indicies of uniq (non-key) cols in each table progressively from left
  end.

  k_colidx=. (key i.~ {.)&.> y                         NB. indexes of key column(s) in each table
  keys=. k_colidx ({"1 }.)&.> y                        NB. boxed key columns for each table

  select. m
  case. 'inner' do.
    k2k=. ; intersect&.>/ keys                           NB. key values to keep in result (depends on join type)
  case. 'left' do.
    k2k=. ; [&.>/ keys                                   NB. key values to keep in result (depends on join type)
  case. 'right' do.
    k2k=. ; ]&.>/ keys                                   NB. key values to keep in result (depends on join type)
  case. 'outer' do.
    k2k=. ; ,&.>/ keys                                   NB. key values to keep in result (depends on join type)
  case. do.
    echo 'Bad option `m`: ',m
  end.

  ks2k=. k2k&(] #~ e.~)&.> keys                        NB. keys to keep for each table
  jkey=. {. ({. ,~ ] #~ hasDups&>) ks2k                NB. choose keys from "many" table (if there is one) as the target set
  jkey=. k2k <@(] , -.) ; jkey                         NB. ensure that jkey contains all keys from keys 2 keep
  rowidx=. (jkey (i.~)`(pi~)@.(hasDups@])&.>/ ]) keys  NB. get row indices in merge order required from each table
  jdat=. ;,.&.>/ (rowidx <@;&.> colidx) ([ { a: ,~ }.@]) &.> y  NB. build results data using required rows/columns from each table
  jhdr , (;jkey) ,. jdat
)

Note 'example usage'
'Id' left join A;<B
('Id';'Name') left join A;<B
('Id';'Name') left join A;B;<C
('Id';'Name') right join A;B;<C
outer join A;B;<C
)

NB.*join1st a Join tables on 1st column, ignore optional headers
NB. usage: x u join1st y
NB. eg: 1 left join1st A;B;<C
NB. x is:  optional boolean specifying headers are present. Default is 0
NB. y is:  list of boxed tables to join on first column
NB. u is: join strategy to use (left, right, inner, outer)
NB. Assumes field in 1st column is common to all tables, and all others are unique.
NB. Tables can either be all numeric or all boxed.
join1st=: adverb define
  0 u join1st y
:
  hdr=. x                                NB. are headers present?
  if. hdr do.                            NB. handle when tables have a header row
    hdrs=. {.&.> y
    jhdr=. ({.@>@{. , [: ; }.&.>) hdrs   NB. header in joined
    dats=. }.&.> y
  else.
    jhdr=. 0 0$0                         NB. header in joined
    dats=. y
  end.
  assert. ({. = }.) datatype&.> dats     NB. check all tables the same datatype?
  missing=. (a:;_9999) {::~ isnumeric 0{:: dats
  jkey=. ~.; u&.>/ ({."1)&.> dats        NB. key col in joined
  ridx=. (jkey i.~ {."1)&.> dats
  cidx=. }.@i.@{:@$&.> dats              NB. all cols except first in each table
  jdat=. ;,.&.>/ (ridx <@;&.> cidx) ([ { missing ,~ ]) &.> dats  NB. data cols in joined
  jhdr , jkey ,. jdat  
)

Note 'example usage'
   1 left join1st A;<B
   0 left join1st A;<B
   0 left join1st A;B;<C
   0 right join1st A;B;<C
   inner join1st A;<B
)

Note 'dpylr analogues'
see https://www.juliabloggers.com/data-wrangling-in-julia-based-on-dplyr-flights-tutorials/
see http://genomicsclass.github.io/book/pages/dplyr_tutorial.html
require 'web/gethttp'
url=: 'https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/msleep_ggplot2.csv'
msleep=: fixcsv gethttp url
'genus' (<'Ovis')&= filter msleep
'order' e.&('Perissodactyla';'Primates') filter msleep
'sl' starts_with select msleep
'sleep_total' >&16 filter msleep
)

matches=: boxopen@[
starts_with=: ] #~ boxopen@[ = #@[ {.&.> ]
ends_with=: ] #~ boxopen@[ = -@#@[ {.&.> ]
contains=: ] #~ boxopen@[ +./@:E.&> ]

select=: adverb define
:
  (] {"1~ {. i. x u {.) y
)

filter=: adverb define
:
  'hdr dat'=. split y
  tmp=. dat {"1~ hdr i. boxopen x
  msk=. u (_9999 ". >)^:isNumericField tmp
  hdr , dat #~ msk
)

arrange=: verb define
:
  'hdr dat'=. split y
  tmp=. dat {"1~ hdr i. boxopen x
  dat /: makenum tmp
)
