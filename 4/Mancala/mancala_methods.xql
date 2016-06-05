
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
 as xs:integer
 {
    let $p := $pit
     return ($pit/text())
 };
 
 declare function local:seedsInPit2($game, $pitNumber)
 as xs:integer
 {
    let $p := $game/pits/top/pit[$pitNumber]
    return ($p/text())
 };
 
 declare function local:setSeedsInPitTo($game,$pitNumber, $targetNumber)
 {
 
    let $oldGame := $game
    return
        copy $g := $oldGame
        modify(
            replace value of node $g/pits/top/pit[$pitNumber] with $targetNumber
        )
        return ($g)
        
 };
 
 declare function local:increaseSeedsInPitBy1($pit)
 {
    let $p := $pit
    return $p
 };
 
 
 
 declare function local:__increasePitsBy1($game, $index, $remaining)
 {
    if( $remaining = 0) then (
        $game
    )
    else  (
        let $newGame := local:setSeedsInPitTo($game, $index, local:seedsInPit2($game, $index) + 1)
        return local:__increasePitsBy1($newGame, $index + 1, $remaining - 1)
    )
 };
 
 
 declare function local:increasePitsBy1($game, $startingAt, $times)
 {
    let $foo := 1
    return (local:__increasePitsBy1($game, $startingAt, $times + 1)) 
 
 };
 
 declare function local:playerSelectedPit($player, $pitNumber, $game)
 {
    let $pit := $game/pits/top/pit[$pitNumber]
    let $seedsInPit := local:seedsInPit($pit)
    let $seedsEmpty := local:setSeedsInPitTo($game, $pitNumber, 0)
   
    let $seedsIncreased := local:increasePitsBy1($seedsEmpty, $pitNumber + 1, $seedsInPit)
    
    return ($seedsIncreased)
    
    
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