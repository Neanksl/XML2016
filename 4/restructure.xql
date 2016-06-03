for $topPit in fn:doc("Stats.xml/pits/top")
return (insert node <value>{string($topPit)}</value> as first into $topPit)

(:return (insert node <id>{string($s/@id)}</id> as first into $s, delete node $s/@id):)