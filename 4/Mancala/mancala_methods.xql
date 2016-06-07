(: Andreas Eichner, Michael Conrads :)
declare namespace player = "mancala:player";
declare namespace house = "mancala:house";
declare namespace pit = "mancala:pit";
declare namespace board = "mancala:board";
(: player class :)


(: house class :)

 declare updating function house:incSeedCount($this, $amount)
 {
    replace value of node $this with $this + $amount
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
        for $p in $this/top/pit
        where $p/@id = $pitId
        return $p
        )
    else
    (
        for $p in $this/bottom/pit
        where $p/@id = $pitId
        return $p
    )
};

 
declare function board:getHouseWithId($this, $houseId as xs:integer)
{
    if($houseId = 7) then
        for $h in $this/top/house
        where $h/@id = $houseId
        return $h
    else
        for $h in $this/bottom/house
        where $h/@id = $houseId
        return $h
        
};



declare updating function board:increaseHouseBy1($this, $startingAt, $times, $old, $active)
 {
    if($times > 0 and ($old != $startingAt or $active)) then
         board:_increaseHouseBy1($this, $startingAt, $times, $old, $active)
    else ()   
 };
 
 
declare updating function board:_increaseHouseBy1($this, $startingAt, $times, $old, $active)
 {
        house:incSeedCount( board:getHouseWithId($this, $startingAt), 
                                  (($times - 1) idiv 14) + 1),
     
        if( $startingAt = 14) then
            board:increasePitsBy1($this, 1, $times - 1,$old, false())
        else
            board:increasePitsBy1($this, $startingAt + 1, $times - 1,$old, false()) 
 };
 


 
 declare updating function board:increasePitsBy1($this, $startingAt, $times, $old, $active)
 {
    if($times > 0 and ($old != $startingAt or $active ) ) then
        board:_increasePitsBy1($this, $startingAt, $times, $old, $active)
    else ()   
 };
 
 
 declare updating function board:_increasePitsBy1($this, $startingAt, $times, $old, $active)
 {
    
    pit:incSeedCount(
                            board:getPitWithId($this, $startingAt),
                            (($times - 1) idiv 14) + 1
                            ),
    
        if ($startingAt = 6 or $startingAt = 13 ) then
            board:increaseHouseBy1($this, $startingAt + 1, $times - 1,$old, false())
        else 
            board:increasePitsBy1($this, $startingAt + 1, $times - 1,$old, false())
 };
 
 
 
 declare updating function board:distributeSeeds($this, $clickedPit, $times)
 {
    if ($clickedPit = 7 or $clickedPit = 14 ) then
            board:increaseHouseBy1($this, $clickedPit + 1, $times, $clickedPit, true())
        else 
            board:increasePitsBy1($this, $clickedPit + 1, $times, $clickedPit, true())
 };

 declare updating function board:clickedPit($this, $pitNumber)
 {
    pit:setSeedCount(
            board:getPitWithId($this, $pitNumber), 
            pit:getSeedCount(board:getPitWithId($this, $pitNumber)) idiv 14),
    
    board:distributeSeeds($this, $pitNumber, 
                   pit:getSeedCount(board:getPitWithId($this, $pitNumber)))
 };
 
 
 
 board:clickedPit(
    fn:doc("gamestate.xml")/game/board, 
    1
    )
 
 