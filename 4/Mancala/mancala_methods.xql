(: Andreas Eichner, Michael Conrads :)

declare namespace players = "mancala:players";
declare namespace player = "mancala:player";
declare namespace house = "mancala:house";
declare namespace pit = "mancala:pit";
declare namespace board = "mancala:board";
declare namespace game = "mancala:game";

(: players class :)
declare function players:getCurrentPlayer($this)
{
    let $turnId := $this/turn
    for $player in $this/player
    where $player/id = $turnId
    return $player
};

declare updating function players:setNextPlayer($this, $nextPlayer)
{
    replace value of node $this/turn with $nextPlayer/id
};

declare updating function players:setNextPlayerWithId($this, $id)
{
    replace value of node $this/turn with $id
};

declare updating function players:toggleCurrentPlayer($this)
{
    players:setNextPlayer($this,
        if ( players:getCurrentPlayer($this)/id = 1 ) then
            $this/player[2]
        else 
            $this/player[1] )
};


(: player class :)
declare updating function player:increaseWinCount($this)
{
    replace value of node $this/winCount with $this/winCount + 1
};

declare updating function player:resetWinCount($this)
{
    replace value of node $this/winCount with 0
};



(: house class :)
 declare updating function house:incSeedCount($this, $amount)
 {
    replace value of node $this with $this + $amount
 };

declare updating function house:setSeedCount($this, $amount)
 {
    replace value of node $this with $amount
 };




(: pit class :)
 declare function pit:getSeedCount($this)
 as xs:integer
 {
    let $this := $this
    return $this
 };
 
 declare updating function pit:setSeedCount($this, $count)
 {
    replace value of node $this with $count
 };


 declare updating function pit:incSeedCount($this, $amount)
 {
    replace value of node $this with $this + $amount
 };


(: board class :)
declare function board:getPitWithId($this, $pitId as xs:integer)
{
    if($pitId < 7) then (
        for $p in $this/layer[@position = "top"]/pit
        where $p/@id = $pitId
        return $p
        )
    else
    (
        for $p in $this/layer[@position = "bottom"]/pit
        where $p/@id = $pitId
        return $p
    )
};

 
declare function board:getHouseWithId($this, $houseId as xs:integer)
{
    if($houseId = 7) then
        for $h in $this/layer[@position = "top"]/house
        where $h/@id = $houseId
        return $h
    else
        for $h in $this/layer[@position = "bottom"]/house
        where $h/@id = $houseId
        return $h
        
};


declare updating function board:_increaseHouseBy1($this, $startingAt, $times, $old, $active)
 {
    if($times > 0 and ($old != $startingAt or $active)) then
        (
        house:incSeedCount( board:getHouseWithId($this, $startingAt), 
                                  (($times - 1) idiv 14) + 1),
                                  
        if( $startingAt = 14) then
            board:_increasePitsBy1($this, 1, $times - 1,$old, false())
        else
            board:_increasePitsBy1($this, $startingAt + 1, $times - 1,$old, false()) 
         )
    else ()   
 };
 
 
 declare updating function board:_increasePitsBy1($this, $startingAt, $times, $old, $active)
 {
    if($times > 0 and ($old != $startingAt or $active ) ) then
        (
        pit:incSeedCount(
                            board:getPitWithId($this, $startingAt),
                            (($times - 1) idiv 14) + 1
                            ),
    
        if ($startingAt = 6 or $startingAt = 13 ) then
            board:_increaseHouseBy1($this, $startingAt + 1, $times - 1,$old, false())
        else 
            board:_increasePitsBy1($this, $startingAt + 1, $times - 1,$old, false())
        )
    else ()   
 };
 

 
 declare updating function board:distributeSeeds($this, $clickedPit, $times)
 {
    if ($clickedPit = 7 or $clickedPit = 14 ) then
            board:_increaseHouseBy1($this, $clickedPit + 1, $times, $clickedPit, true())
        else 
            board:_increasePitsBy1($this, $clickedPit + 1, $times, $clickedPit, true())
 };

 declare updating function board:clickedPit($this, $pitId)
 {
    pit:setSeedCount(
            board:getPitWithId($this, $pitNumber), 
            pit:getSeedCount(board:getPitWithId($this, $pitId)) idiv 14),
    
    board:distributeSeeds($this, $pitNumber, 
                   pit:getSeedCount(board:getPitWithId($this, $pitId)))
 };
 
 
 declare updating function board:resetBoard($this, $startSeeds)
 {
    for $pit in $this/layer/pit 
    return replace value of node $pit with $startSeeds,
    
    for $house in $this/layer/house 
    return replace value of node $house with 0
 };
 
 declare updating function game:resetGame($this)
 {
    board:resetBoard($this/board, 3),
    players:setNextPlayerWithId($this/players, 1)
 };
 
      
 board:clickedPit(
    fn:doc("gamestate.xml")/game/board, 
    1
    ) 
    
 (:
 game:resetGame(fn:doc("gamestate.xml")/game)
 
 
 board:resetBoard(
    fn:doc("gamestate.xml")/game/board, 
    3
    )
 
 
 let $current := players:getCurrentPlayer(fn:doc("gamestate.xml")/game/players)
 return $current
 
players:setNextPlayer(fn:doc("gamestate.xml")/game/players,
                      fn:doc("gamestate.xml")/game/players/player[1]
)


players:toggleCurrentPlayer(fn:doc("gamestate.xml")/game/players)
:)
