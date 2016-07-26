module namespace board = "board";

import module namespace store = 'store' at 'store.xqm';
import module namespace house = 'house' at 'house.xqm';
import module namespace players = 'players' at 'players.xqm';

(: board class :)

(:-------------------------------------:)
(:Public methods:)

declare updating function board:clickedHouse($this, $houseId, $game)
{
    house:setSeedCount(
        board:_getHouseWithId($this, $houseId),
        house:getSeedCount(board:_getHouseWithId($this, $houseId)) idiv 14),
    
    board:_distributeSeeds($this, $houseId,
        house:getSeedCount(board:_getHouseWithId($this, $houseId))),
    
    if (board:_isLastStoneMyHouse($this, $game/players,$houseId, 
            house:getSeedCount(board:_getHouseWithId($this, $houseId))) ) then
       ( 
       (: play again if the last stone hits in own pit :) 
       )
       
    else
        players:toggleCurrentPlayer($game/players) 
};


declare function board:getStoreWithId($this, $storeId as xs:integer)
{
    if ($storeId = 7) then
        for $h in $this/layer[@position = "top"]/store
        where $h/@id = $storeId
        return
            $h
    else
        for $h in $this/layer[@position = "bottom"]/store
        where $h/@id = $storeId
        return
            $h
};

declare function board:sumOfStoreAndRow($this, $position as xs:string) as xs:integer
{
    let $row := $this/layer[@position = $position]
    return xs:integer(sum($row/store)) + xs:integer(sum($row/house))
};

declare function board:isRowEmpty($this, $position as xs:string) as xs:boolean
{
    let $houses := $this/layer[@position = $position]/house
    return
        sum($houses) = 0
};

declare updating function board:clearHouses($this, $position as xs:string)
{
    if($position = "top") then
        board:_setHousesInRangeTo($this, 1, 6, 0)
    else
        board:_setHousesInRangeTo($this, 8, 13, 0)
};

(:-------------------------------------:)
(:Private methods:)

declare function board:_getHouseWithId($this, $houseId as xs:integer)
{
    if ($houseId < 7) then
        (
        for $p in $this/layer[@position = "top"]/house
        where $p/@id = $houseId
        return
            $p
        )
    else
        (
        for $p in $this/layer[@position = "bottom"]/house
        where $p/@id = $houseId
        return
            $p
        )
};


declare updating function board:_increaseStoreBy1($this, $startingAt, $times, $old, $active)
{
    if ($times > 0 and ($old != $startingAt or $active)) then
        (
        store:incSeedCount(board:getStoreWithId($this, $startingAt),
        (($times - 1) idiv 14) + 1),
        
        if ($startingAt = 14) then
            board:_increaseHousesBy1($this, 1, $times - 1, $old, false())
        else
            board:_increaseHousesBy1($this, $startingAt + 1, $times - 1, $old, false())
        )
    else
        ()
};

declare updating function board:_increaseHousesBy1($this, $startingAt, $times, $old, $active)
{
    if ($times > 0 and ($old != $startingAt or $active)) then
        (
        house:incSeedCount(
        board:_getHouseWithId($this, $startingAt),
        (($times - 1) idiv 14) + 1
        ),
        
        if ($startingAt = 6 or $startingAt = 13) then
            board:_increaseStoreBy1($this, $startingAt + 1, $times - 1, $old, false())
        else
            board:_increaseHousesBy1($this, $startingAt + 1, $times - 1, $old, false())
        )
    else
        ()
};

declare updating function board:_distributeSeeds($this, $clickedHouse, $times)
{
    if ($clickedHouse = 6 or $clickedHouse = 13) then
        board:_increaseStoreBy1($this, $clickedHouse + 1, $times, $clickedHouse, true())
    else
        board:_increaseHousesBy1($this, $clickedHouse + 1, $times, $clickedHouse, true())
};


declare function board:_isLastStoneMyHouse($this, $players, $houseId, $numStones)
{
    (: get distance from :)
    let $playerHouseId := players:getHouseIdForCurrentPlayer($players)
    return $houseId + ($numStones mod 14) = $playerHouseId 
};


declare updating function board:_setHousesInRangeTo($this, $startIndex, $lastIndex, $value)
{
    if($startIndex < $lastIndex + 1) then
    (
        house:setSeedCount(board:_getHouseWithId($this,$startIndex), $value),
        board:_setHousesInRangeTo($this, $startIndex + 1, $lastIndex, $value)
    )
    else ()
};


