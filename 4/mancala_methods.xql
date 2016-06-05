
declare namespace functx = "http://www.functx.com";
declare function functx:replace-element-values
  ( $elements as element()* ,
    $values as xs:anyAtomicType* )  as element()* {

   for $element at $seq in $elements
   return element { node-name($element)}
             { $element/@*,
               $values[$seq] }
 } ;
 
 
 declare function local:playerTurn($players)
 as xs:decimal
 {
    let $p := 1
    return (-1)
 };
 
 declare function local:gameFinished($pits)
 as xs:boolean
 {
    let $p := 1
    return false()
 };
 
 (:declare function local:increaseWinCountBy1($player)
 {
 
 }:)
 
 declare function local:seedsInPit($pit)
 {
    let $p := $pit
     return ($pit/text())
 };
 
 declare function local:setSeedsInPitTo0($game,$pitNumber)
 {
    let $oldGame := $game
    return
        copy $g := $oldGame
        modify(
            replace value of node $g/pits/top/pit[$pitNumber] with 0
        )
        return ($g)
 };
 
 declare function local:increaseSeedsInPutBy1($pit)
 {
    let $p := $pit
    return (0)
 };
 
 declare function local:playerSelectedPit($player, $pitNumber, $game)
 {
    let $pit := $game/pits/top/pit[$pitNumber]
    let $seedsInPit := local:seedsInPit($pit)
    let $seedsEmpty := local:setSeedsInPitTo0($game, $pitNumber)
    
    return ($seedsEmpty)
  (: seeds verteilen :)
    
 };
 
 let $game := fn:doc("gamestate.xml")/gamestate
 let $playerID := 1
 let $selectedPit := 1
 return (local:playerSelectedPit($playerID, $selectedPit, $game))
 
 (:
 
declare function local:getPitsFromMancala($m )
{
    let $s := $m/game/pits
    return $s
};

declare function local:increasePitCount($pit, $increaseBy as xs:decimal)
{
    let $p := $pit
    return (functx:replace-element-values($pit, $pit/text() + $increaseBy))
};

let $m := fn:doc("Stats.xml")
let $pits := local:getPitsFromMancala($m)
let $playerTurn := local:playerTurnFrom
return ( local:increasePitCount($pits, 1) )
:)

(:
(\:<id>{string($s)}</id> as first into $s, delete node $s/@id):\)
(\:

functx:add-attributes(
  $in-xml/a,
  (xdmp:node-insert-after('att1','att2')) or (xdmp:node-insert-before('att1','att2')),(1,2)).
  
  
  for $x in doc('Document2')//a
return 
insert node attribute att2{'2'} into $x:\):\):)

(:for $topPit in fn:doc("Stats.xml")
return (insert node <value>{string($topPit)}</value> as first into $topPit)
:)
(:return (insert node <id>{string($s/@id)}</id> as first into $s, delete node $s/@id):)