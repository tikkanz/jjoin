NB.=========================================================
NB. Joining/Merging tables

NB. Set operations on lists
intersect=: [ -. -.   NB. items common to both x and y
union=: ,             NB. items from both x and y
left=: [ , [ #~ e.    NB. items of x and y that occur in x
right=: left~         NB. items of x and y that occur in y
inner=: union ([ #~ e.) intersect  NB. items of x and y that occur in both x and y
outer=: union         NB. items of x and y that occur in either x or y

NB.*join a Join tables on key columns using join strategy
NB. eg: (<'Id') left join A;<B
NB. form: x u join y
NB. x is: list of of key labels (optional, default is first field)
NB. y is: list of boxed tables to merge
NB. u is: verb strategy for joining table indicies. One of left, right, inner, outer
join=: adverb define
  key=. {.{. >@{. y                                     NB. default key is first field
  key u join y
:
  key=. boxopen x
  if. (right`'') = (u`'') do.  NB. handle when left & right have non-key fields in common
    mhdr=. key , key -.~ ~. &.|. ; {.&.> y                  NB. header in merged
    cidx=. (] i.&.> [: }. [: -.~&.>/\ key ; ])&.|. {.&.> y  NB. add uniq cols progressively from left
  else.
    mhdr=. key , key -.~ ~. ; {.&.> y                       NB. header in merged
    cidx=. (] i.&.> [: }. [: -.~&.>/\ key ; ]) {.&.> y      NB. add uniq cols progressively from left
  end.
  mkey=. ~.; u&.>/ ((key i.~ {.) {"1 }.)&.> y               NB. key cols in merged
  ridx=. (mkey i.~ }. {"1~ key i.~ {.)&.> y
  mdat=. ;,.&.>/ (ridx <@;&.> cidx) ([ { a: ,~ }.@]) &.> y
  mhdr , mkey ,. mdat
)

Note 'example usage'
'Id' left join A;<B
('Id';'Name') left join A;<B
('Id';'Name') left join A;B;<C
('Id';'Name') right join A;B;<C
outer join A;B;<C
)

NB.*merge c Merge two tables on specified index fields
NB. eg: A (<'Name') merge outer B
NB. form: x m merge v y
NB. x y are: Tables with field labels in first row
NB. m is: list of boxed labels of columns to use as index
NB. v is: verb strategy for joining table indicies
merge=: conjunction define
:
  key=. boxopen m
  mhdr=. key , key -.~ ~. x ,&{. y         NB. header in merged
  mkey=. ~. x v&:((key i.~ {.) {"1 }.) y   NB. key cols in merged
  l_cidx=. x ([ i. key -.~ [ -. -.~)&{. y  NB. cols not in right or key
  r_cidx=. y (] i. -.~)&{. x               NB. cols only in right
  l_ridx=. mkey i.~ (}. {"1~ key i.~ {.) x
  r_ridx=. mkey i.~ (}. {"1~ key i.~ {.) y
  mdat=. ((<l_ridx;l_cidx) { a: ,~ }.x) ,. (<r_ridx;r_cidx) { a: ,~ }.y
  mhdr , mkey ,. mdat
)

Note 'example usage'
A 'Id' merge left B
A ('Id';'Name') merge left B
A ('Id';'Name') merge right B
A 'Id' merge outer B
)
