

module namespace page = 'http://basex.org/modules/web-page';
(:
declare namespace players = "http://basex.org/modules/web-page/players";
declare namespace player = "http://basex.org/modules/web-page/player";
declare namespace house = "http://basex.org/modules/web-page/house";
declare namespace pit = "http://basex.org/modules/web-page/pit";
declare namespace board = "http://basex.org/modules/web-page/board";
declare namespace game = "http://basex.org/modules/web-page/game";
:)

(: players class :)
declare function page:players_getCurrentPlayer($this)
{
    let $turnId := $this/turn
    for $player in $this/player
    where $player/id = $turnId
    return $player
};

declare updating function page:players_setNextPlayer($this, $nextPlayer)
{
    replace value of node $this/turn with $nextPlayer/id
};

declare updating function page:players_setNextPlayerWithId($this, $id)
{
    replace value of node $this/turn with $id
};

declare updating function page:players_toggleCurrentPlayer($this)
{
    page:players_setNextPlayer($this,
        if ( page:players_getCurrentPlayer($this)/id = 1 ) then
            $this/player[2]
        else 
            $this/player[1] )
};


(: player class :)
declare updating function page:player_increaseWinCount($this)
{
    replace value of node $this/winCount with $this/winCount + 1
};

declare updating function page:player_resetWinCount($this)
{
    replace value of node $this/winCount with 0
};



(: house class :)
 declare updating function page:house_incSeedCount($this, $amount)
 {
    replace value of node $this with $this + $amount
 };

declare updating function page:house_setSeedCount($this, $amount)
 {
    replace value of node $this with $amount
 };




(: pit class :)
 declare function page:pit_getSeedCount($this)
 as xs:integer
 {
    let $this := $this
    return $this
 };
 
 declare updating function page:pit_setSeedCount($this, $count)
 {
    replace value of node $this with $count
 };


 declare updating function page:pit_incSeedCount($this, $amount)
 {
    replace value of node $this with $this + $amount
 };


(: board class :)
declare function page:board_getPitWithId($this, $pitId as xs:integer)
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

 
declare function page:board_getHouseWithId($this, $houseId as xs:integer)
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


declare updating function page:board_increaseHouseBy1($this, $startingAt, $times, $old, $active)
 {
    if($times > 0 and ($old != $startingAt or $active)) then
        (
        page:house_incSeedCount( page:board_getHouseWithId($this, $startingAt), 
                                  (($times - 1) idiv 14) + 1),
                                  
        if( $startingAt = 14) then
            page:board_increasePitsBy1($this, 1, $times - 1,$old, false())
        else
            page:board_increasePitsBy1($this, $startingAt + 1, $times - 1,$old, false()) 
         )
    else ()   
 };
 
 
 declare updating function page:board_increasePitsBy1($this, $startingAt, $times, $old, $active)
 {
    if($times > 0 and ($old != $startingAt or $active ) ) then
        (
        page:pit_incSeedCount(
                            page:board_getPitWithId($this, $startingAt),
                            (($times - 1) idiv 14) + 1
                            ),
    
        if ($startingAt = 6 or $startingAt = 13 ) then
            page:board_increaseHouseBy1($this, $startingAt + 1, $times - 1,$old, false())
        else 
            page:board_increasePitsBy1($this, $startingAt + 1, $times - 1,$old, false())
        )
    else ()   
 };
 

 
 declare updating function page:board_distributeSeeds($this, $clickedPit, $times)
 {
    if ($clickedPit = 7 or $clickedPit = 14 ) then
            page:board_increaseHouseBy1($this, $clickedPit + 1, $times, $clickedPit, true())
        else 
            page:board_increasePitsBy1($this, $clickedPit + 1, $times, $clickedPit, true())
 };

 declare 
 updating function page:board_clickedPit($this, $pitId)
 {
    page:pit_setSeedCount(
            page:board_getPitWithId($this, $pitId), 
            page:pit_getSeedCount(page:board_getPitWithId($this, $pitId)) idiv 14),
    
    page:board_distributeSeeds($this, $pitId, 
                   page:pit_getSeedCount(page:board_getPitWithId($this, $pitId)))
 };
 
 
 declare  
 %rest:path("clicked/{$pitId}")
 updating function page:clickedPit($pitId)
 {
 let $x := 1
    return (
        
        page:board_clickedPit(page:getDB()/game/board, xs:integer($pitId))
        (: 
        <rest:forward>/</rest:forward> 
        return page:getDB()
        :)
    )
 };
 
 
 
 declare updating function page:game_resetBoard($this, $startSeeds)
 {
    for $pit in $this/layer/pit 
    return replace value of node $pit with $startSeeds,
    
    for $house in $this/layer/house 
    return replace value of node $house with 0
 };
 
 declare updating function page:game_resetGame($this)
 {
    page:game_resetBoard($this/board, 3),
    page:players_setNextPlayerWithId($this/players, 1)
 };


declare function page:getDB()
{
   let $db := db:open("mancala-db")
   return $db
};


declare
  %rest:path("")
  function page:start()
{
<html>
     <body>
     <h1>hello world</h1>
     <p>from db:</p>
     <p>{page:getDB()}</p>
</body>
       
     </html>
};




declare
%rest:path("db/create")
%rest:GET
updating function page:createDB()
{
    let $db := <game>
    <board>
        <layer position="top">
            <pit id="1">3</pit>
            <pit id="2">3</pit>
            <pit id="3">3</pit>
            <pit id="4">3</pit>
            <pit id="5">3</pit>
            <pit id="6">3</pit>
            
            <house id="7">0</house>
        </layer>
        
        <layer position="bottom">
            <pit id="8">3</pit>
            <pit id="9">3</pit>
            <pit id="10">3</pit>
            <pit id="11">3</pit>
            <pit id="12">3</pit>
            <pit id="13">3</pit>
            
            <house id="14">0</house>
        </layer>
    </board>
    
    <players>
        <turn>1</turn>
        
        <player>
            <id>1</id>
            <winCount>2</winCount>
        </player>
        
        <player>
            <id>2</id>
            <winCount>0</winCount>
        </player>
    </players>
</game>

    return
        db:create("mancala-db", $db, "mancala-db.xml")
};


