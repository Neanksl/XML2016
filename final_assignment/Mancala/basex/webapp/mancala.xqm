

module namespace page = 'http://basex.org/modules/web-page';

(:
declare namespace players = "http://basex.org/modules/web-page/players";
declare namespace player = "http://basex.org/modules/web-page/player";
declare namespace store = "http://basex.org/modules/web-page/store";
declare namespace house = "http://basex.org/modules/web-page/house";
declare namespace board = "http://basex.org/modules/web-page/board";
declare namespace game = "http://basex.org/modules/web-page/game";
:)

(: players class :)
declare function page:players_getCurrentPlayer($this)
{
    let $turnId := $this/turn
    for $player in $this/player
    where $player/id = $turnId
    return
        $player
};

declare updating function page:players_setNextPlayer($this, $nextPlayer)
{
    replace value of node $this/turn
        with $nextPlayer/id
};

declare updating function page:players_setNextPlayerWithId($this, $id)
{
    replace value of node $this/turn
        with $id
};

declare updating function page:players_toggleCurrentPlayer($this)
{
    page:players_setNextPlayer($this,
    if (page:players_getCurrentPlayer($this)/id = 1) then
        $this/player[2]
    else
        $this/player[1])
};

declare function page:players_getHouseIdForCurrentPlayer($this)
{
    let $x := 1
    return ( if(page:players_getCurrentPlayer($this)/id = 1) then
        7
    else
        14 )
};

(: player class :)
declare updating function page:player_increaseWinCount($this)
{
    replace value of node $this/winCount
        with $this/winCount + 1
};

declare updating function page:player_resetWinCount($this)
{
    replace value of node $this/winCount
        with 0
};

(: store class :)
declare updating function page:store_incSeedCount($this, $amount)
{
    replace value of node $this
        with $this + $amount
};

declare updating function page:store_setSeedCount($this, $amount)
{
    replace value of node $this
        with $amount
};

declare function page:store_getSeedCount($this)
as xs:integer
{
    let $this := $this
    return
        $this
};

(: house class :)
declare function page:house_getSeedCount($this)
as xs:integer
{
    let $this := $this
    return
        $this
};

declare updating function page:house_setSeedCount($this, $count)
{
    replace value of node $this
        with $count
};


declare updating function page:house_incSeedCount($this, $amount)
{
    replace value of node $this
        with $this + $amount
};


(: board class :)


declare function page:board_getHouseWithId($this, $houseId as xs:integer)
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


declare function page:board_getStoreWithId($this, $storeId as xs:integer)
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


declare updating function page:board_increaseStoreBy1($this, $startingAt, $times, $old, $active)
{
    if ($times > 0 and ($old != $startingAt or $active)) then
        (
        page:store_incSeedCount(page:board_getStoreWithId($this, $startingAt),
        (($times - 1) idiv 14) + 1),
        
        if ($startingAt = 14) then
            page:board_increaseHousesBy1($this, 1, $times - 1, $old, false())
        else
            page:board_increaseHousesBy1($this, $startingAt + 1, $times - 1, $old, false())
        )
    else
        ()
};

declare updating function page:board_increaseHousesBy1($this, $startingAt, $times, $old, $active)
{
    if ($times > 0 and ($old != $startingAt or $active)) then
        (
        page:house_incSeedCount(
        page:board_getHouseWithId($this, $startingAt),
        (($times - 1) idiv 14) + 1
        ),
        
        if ($startingAt = 6 or $startingAt = 13) then
            page:board_increaseStoreBy1($this, $startingAt + 1, $times - 1, $old, false())
        else
            page:board_increaseHousesBy1($this, $startingAt + 1, $times - 1, $old, false())
        )
    else
        ()
};

declare updating function page:board_distributeSeeds($this, $clickedHouse, $times)
{
    if ($clickedHouse = 6 or $clickedHouse = 13) then
        page:board_increaseStoreBy1($this, $clickedHouse + 1, $times, $clickedHouse, true())
    else
        page:board_increaseHousesBy1($this, $clickedHouse + 1, $times, $clickedHouse, true())
};


declare function page:board_isLastStoneMyHouse($this, $players, $houseId, $numStones)
{
    (: get distance from :)
    let $playerHouseId := page:players_getHouseIdForCurrentPlayer($players)
    return $houseId + ($numStones mod 14) = $playerHouseId 
};
    
declare updating function page:game_log($game, $message)
{
    replace value of node $game/logMessage with $message
};

declare updating function page:board_clickedHouse($this, $houseId, $game)
{
    page:house_setSeedCount(
        page:board_getHouseWithId($this, $houseId),
        page:house_getSeedCount(page:board_getHouseWithId($this, $houseId)) idiv 14),
    
    page:board_distributeSeeds($this, $houseId,
        page:house_getSeedCount(page:board_getHouseWithId($this, $houseId))),
    
    if (page:board_isLastStoneMyHouse($this, $game/players,$houseId, 
            page:house_getSeedCount(page:board_getHouseWithId($this, $houseId))) ) then
       ( 
       (: play again if the last stone hits in own pit :) 
       )
       
    else
        ( page:players_toggleCurrentPlayer($game/players) )
};


declare function page:board_rowIsEmpty($this, $position as xs:string)
as xs:boolean
{
    let $houses := $this/layer[@position = $position]/house
    return
        sum($houses) = 0
};

declare function page:board_sumOfStoreAndRow($this, $position as xs:string)
as xs:integer
{
    let $row := $this/layer[@position = $position]
    return xs:integer(sum($row/store)) + xs:integer(sum($row/house))
};


declare updating function page:board_setHouseTo($this, $startIndex, $lastIndex, $value)
{
    if($startIndex < $lastIndex + 1) then
    (
        page:house_setSeedCount(page:board_getHouseWithId($this,$startIndex), $value),
        page:board_setHouseTo($this, $startIndex + 1, $lastIndex, $value)
    )
    else ()
};

declare updating function page:board_clearHouses($this, $position as xs:string)
{
    if($position = "top") then
        page:board_setHouseTo($this, 1, 6, 0)
    else
        page:board_setHouseTo($this, 8, 13, 0)
};

declare updating function page:game_UpdateWinner($this)
{
        if (page:board_sumOfStoreAndRow($this/board, "top") > page:board_sumOfStoreAndRow($this/board, "bottom") ) then
            (replace value of node $this/wonBy
                with 1, 
                page:player_increaseWinCount($this/players/player[1])
                )
        else
            (replace value of node $this/wonBy
                with 2,
                page:player_increaseWinCount($this/players/player[2])
                )
    
};

declare
updating function page:game_checkForGameFinished($this)
{
    
    if (page:board_rowIsEmpty($this/board, "top")) then
        (
        page:store_setSeedCount(
        (: store:)
        page:board_getStoreWithId($this/board, 14),
        
        (: store + sum of top row:)
        page:board_sumOfStoreAndRow($this/board, "bottom")
        ),
        page:board_clearHouses($this/board,"bottom"),
        page:game_UpdateWinner($this)
        )
    
    else
        (
        if (page:board_rowIsEmpty($this/board, "bottom")) then
            
            (
                page:board_clearHouses($this/board,"top"),
                page:store_setSeedCount(
            (: store:)
                    page:board_getStoreWithId($this/board, 7), 
            
            (: store + sum of top row :)
                    page:board_sumOfStoreAndRow($this/board, "top")
                ),
            
            page:game_UpdateWinner($this)
            
            )
        else
            ()
        )
};

declare updating function page:game_clicked($this, $id)
{
    page:board_clickedHouse($this/board, xs:integer($id), $this)
};





declare
%rest:path("/updategamefinished/{$dbID}")
updating function page:checkIfGameIsFinished($dbID)
{
    let $x := 1
    return
        (
        db:output(page:redirect(concat("/game/",$dbID))),
        page:game_checkForGameFinished(page:getDB($dbID)/game)
        )
};

declare
%rest:path("clicked/{$dbID}/{$houseId}")
updating function page:clickedHouse($dbID, $houseId)
{
    let $x := 1
    return
        (
        db:output(page:redirect(concat("/updategamefinished/",$dbID))),
        page:game_clicked(page:getDB($dbID)/game, xs:integer($houseId))
        )
};


declare updating function page:game_resetBoard($this, $startSeeds)
{
    for $house in $this/layer/house
    return
        replace value of node $house
            with $startSeeds,
    
    for $store in $this/layer/store
    return
        replace value of node $store
            with 0
};

declare updating function page:game_resetGame($this)
{
    page:game_resetBoard($this/board, 4),
    page:players_setNextPlayerWithId($this/players, 1),
    replace value of node $this/wonBy with 0
};



declare
%rest:path("gamestate/{$dbID}")
function page:gamestate($dbID)
{
    page:getDB($dbID)
};

declare
%rest:path("gettransform/{$dbID}")
function page:getTransform($dbID)
{
    doc("./static/Static.xml")
};

declare
  %rest:path("debug/testout")
  
function page:cities() 
{
<doc>
<head>
    {doc("static/Static.xml")}    
    {doc("./static/initial_gamestate.xml")}
</head>
</doc>
    
};


declare
    %rest:path("getstatic/{$gameID}")
    %rest:GET
function page:getStatic($gameID)
  as element(Q{http://www.w3.org/1999/xhtml}html)
{
    let $href := concat("http://localhost:8984/gettransform/",$gameID)
    
    let $s := "<?xml version='1.0' encoding='UTF-8'?>\n"
    let $s2 := concat('<?xml-stylesheet href=',$href,' type="text/xsl"?>')
    
    return  concat ( 
            $s,
            $s2,
        <graphics>
            {doc("./static/Static.xml")}
        </graphics>)
    
    
};


declare
%rest:path("/game/{$id}")
%rest:GET
function page:game($id)
{
    page:getStatic($id)
};


declare
%rest:path("/")
%rest:GET
updating function page:index()
{
    let $x := 1
    return
    (
    db:output(page:redirect("/db/create"))
    )
};

declare function page:redirect($redirect as xs:string) as element(restxq:redirect)
{
    <restxq:redirect>{$redirect}</restxq:redirect>
};

declare
%rest:path("tryagain/{$dbID}")
%rest:GET
updating function page:tryAgain($dbID)
{
    let $db := page:getDB($dbID)
    return
        (
        db:output(page:redirect(concat("/game/",$dbID))),
        page:game_resetGame($db/game)
        )
};

declare 
%rest:path("debug/lastID")
%rest:GET
function page:debug__lastGameID()
{
    let $x := 1
    let $db := db:open("games")
    return $db
};

declare function page:_lastGameID()
as xs:integer
{
    let $x := 1
    let $db := db:open("games")
    return xs:integer(max( $db/databases/gameid ))
};


declare updating function page:_addNewGame($newEntry, $games)
{
    insert node $newEntry as last into $games/databases
};



declare function page:getDB($dbID)
{
    let $db := db:open(concat("game-",$dbID))
    return
        $db
};


(: creates a new game and inserts the game id :)
declare
%rest:path("db/create")
%rest:GET
updating function page:createDB()
{
    let $db := doc("./static/initial_gamestate.xml")
    let $games := db:open("games")
    let $lastID := page:_lastGameID()  
    let $nextID := xs:integer($lastID + 1)
    let $path := concat("/game/",$nextID)
    return
        (
        page:_addNewGame(<gameid>{$nextID}</gameid>, $games),
        db:output(page:redirect($path)),
        db:create(concat("game-", $nextID) , $db, concat("game-", $nextID, ".xml"))
        )
};

(: creates the game index :)
declare
%rest:path("db/initgameindex")
%rest:GET
updating function page:initGameIndex()
{
    let $db := doc("./static/database-index.xml")
    return
        (
        db:output(page:redirect("/")),
        db:create("games", $db, "games.xml")
        )
};












(:   testing :)
declare
%rest:path("test/db/create/{$dbname}")
%rest:GET
updating function page:createDB($dbname)
{
    let $db := doc( concat("./static/tests/", $dbname , ".xml"))
    
    return
        (
        db:output(page:redirect("/")),
        db:create("mancala-db", $db, "mancala-db.xml")
        )
};

(:
declare
%rest:path("gamestate/{$dbname}")
function page:gamestate($dbname)
{
    let $db := db:open(concat("./static/tests/", $dbname , ".xml"))
    return
        $db
};:)
