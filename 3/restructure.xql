for $mancala in fn:doc("Stats.xml")/mancala
let $top := $mancala/pits
return (for $pit in $top
let $bot := $top
return trace($top, "text2"))

(:return (insert node <value>myValue</value> as first into $pit):)
(:return (insert node <id>{string($s/@id)}</id> as first into $s, delete node $s/@id):)