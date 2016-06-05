(: Andreas Eichner, Michael Conrads :)


(: player class :)

(: houseclass :)
 declare updating function local:house_incSeedCount($this, $amount)
 {
    replace value of node $this with $this + $amount
 };


(: pit class :) 
 declare function local:pit_getSeedCount($this)
 as xs:integer
 {
    let $this := $this
    return $this
 };
 
 declare updating function local:pit_setSeedCount($this, $count)
 {
    replace value of node $this with $count
 };


 declare updating function local:pit_incSeedCount($this, $amount)
 {
    replace value of node $this with $this + $amount
 };


(: board class :)

 
declare function local:board_getPitWithId($this, $pitId as xs:integer)
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

 
declare function local:board_getHouseWithId($this, $houseId as xs:integer)
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



declare updating function local:board_increaseHouseBy1($this, $startingAt, $times, $old, $active)
 {
    if($times > 0 and ($old != $startingAt or $active)) then
         local:board_guard_increaseHouseBy1($this, $startingAt, $times, $old, $active)
    else ()   
 };
 
 
declare updating function local:board_guard_increaseHouseBy1($this, $startingAt, $times, $old, $active)
 {
        local:house_incSeedCount( local:board_getHouseWithId($this, $startingAt), 
                                  (($times - 1) idiv 14) + 1),
     
        if( $startingAt = 14) then
            local:board_increasePitsBy1($this, 1, $times - 1,$old, false())
        else
            local:board_increasePitsBy1($this, $startingAt + 1, $times - 1,$old, false()) 
 };
 


 
 declare updating function local:board_increasePitsBy1($this, $startingAt, $times, $old, $active)
 {
    if($times > 0 and ($old != $startingAt or $active ) ) then
    local:board_guard_increasePitsBy1($this, $startingAt, $times, $old, $active)
    else ()   
 };
 
 
 declare updating function local:board_guard_increasePitsBy1($this, $startingAt, $times, $old, $active)
 {
    
    local:pit_incSeedCount(
                            local:board_getPitWithId($this, $startingAt),
                            (($times - 1) idiv 14) + 1
                            ),
    
        if ($startingAt = 6 or $startingAt = 13 ) then
            local:board_increaseHouseBy1($this, $startingAt + 1, $times - 1,$old, false())
        else 
            local:board_increasePitsBy1($this, $startingAt + 1, $times - 1,$old, false())
 };
 
 
 
 declare updating function local:board_distributeSeeds($this, $clickedPit, $times)
 {
    if ($clickedPit = 7 or $clickedPit = 14 ) then
            local:board_increaseHouseBy1($this, $clickedPit + 1, $times, $clickedPit, true())
        else 
            local:board_increasePitsBy1($this, $clickedPit + 1, $times, $clickedPit, true())
 };

 declare updating function local:board_playerSelectedPit($this, $player, $pitNumber)
 {
    
    local:pit_setSeedCount(local:board_getPitWithId($this, $pitNumber), local:pit_getSeedCount(local:board_getPitWithId($this, $pitNumber)) idiv 14),
    local:board_distributeSeeds($this, $pitNumber, local:pit_getSeedCount(local:board_getPitWithId($this, $pitNumber)))
 };
 
 
 
 local:board_playerSelectedPit(
    fn:doc("gamestate.xml")/game/board, 
    fn:doc("gamestate.xml")/game/players/playerTop, 
    1
    )
 
 