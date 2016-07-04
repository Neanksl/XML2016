

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
    if ($clickedHouse = 7 or $clickedHouse = 14) then
        page:board_increaseStoreBy1($this, $clickedHouse + 1, $times, $clickedHouse, true())
    else
        page:board_increaseHousesBy1($this, $clickedHouse + 1, $times, $clickedHouse, true())
};

declare
updating function page:board_clickedHouse($this, $houseId)
{
    page:house_setSeedCount(
    page:board_getHouseWithId($this, $houseId),
    page:house_getSeedCount(page:board_getHouseWithId($this, $houseId)) idiv 14),
    
    page:board_distributeSeeds($this, $houseId,
    page:house_getSeedCount(page:board_getHouseWithId($this, $houseId)))
};


declare
%rest:path("clicked/{$houseId}")
updating function page:clickedHouse($houseId)
{
    let $x := 1
    return
        (
        db:output(page:redirect("/")),
        page:board_clickedHouse(page:getDB()/game/board, xs:integer($houseId))
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
    page:game_resetBoard($this/board, 3),
    page:players_setNextPlayerWithId($this/players, 1)
};


declare function page:getDB()
{
    let $db := db:open("mancala-db")
    return
        $db
};


declare
%rest:path("gamestate")
function page:gamestate()
{
    page:getDB()
};

declare
%rest:path("getstatic")
%rest:GET
function page:getStatic()
{
    doc("./static/Static.xml")
};

declare
%rest:path("")
%rest:GET
function page:index()
{
    page:getStatic()
};



declare function page:redirect($redirect as xs:string) as element(restxq:redirect)
{
    <restxq:redirect>{$redirect}</restxq:redirect>
};

declare
%rest:path("db/create")
%rest:GET
updating function page:createDB()
{
    let $db := doc("./static/initial_gamestate.xml")
    
    return
        (
        db:output(page:redirect("/")),
        db:create("mancala-db", $db, "mancala-db.xml")
        )
};

