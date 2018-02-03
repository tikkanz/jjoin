NB.*mergeTables a Merge tables on key columns using join strategy
NB. form: x u merge y
NB. x is: list of of key labels (optional, default is first field)
NB. y is: list of boxed tables to merge
NB. u is: verb strategy for joining table indicies
mergeTables=: 1 :0
  key=. {.{. >@{. y                                   NB. default key is first field
  key u mergeTables y
:
  key=. boxopen x
  mhdr=. key , key -.~ ~. ; {.&.> y                   NB. header in merged
  mkey=. ~.; u&.>/ ((key i.~ {.) {"1 }.)&.> y         NB. key cols in merged
  cidx=. (] i.&.> [: }. [: -.~&.>/\ key ; ]) {.&.> y  NB. add uniq cols progressively from left
  ridx=. (mkey i.~ }. {"1~ key i.~ {.)&.> y
  mdat=. ;,.&.>/ (ridx <@;&.> cidx) ([ { a: ,~ }.@]) &.> y
  mhdr , mkey ,. mdat
)

Note 'example usage'
'Id' joinLeft mergeTables A;<B
('Id';'Name') joinLeft mergeTables A;<B
('Id';'Name') joinLeft mergeTables A;B;<C
('Id';'Name') joinRight mergeTables A;B;<C
joinOuter mergeTables A;B;<C
)
