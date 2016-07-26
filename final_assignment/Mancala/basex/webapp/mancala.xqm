module namespace page = 'http://basex.org/modules/web-page';

import module namespace game = 'game' at 'game.xqm';

declare namespace xsl = "http://www.w3.org/1999/XSL/Transform";


declare
%rest:path("/updategamefinished/{$dbID}")
updating function page:checkIfGameIsFinished($dbID)
{
    let $id := $dbID
    return
        (db:output(page:_redirect(concat("/game/",$id))),
        game:checkForGameFinished(page:_getDB($id)/game))
};

declare
%rest:path("clicked/{$gameID}/{$houseId}")
updating function page:clickedHouse($gameID, $houseId)
{
    let $id := $gameID
    return
        (
        db:output(page:_redirect(concat("/updategamefinished/",$gameID))),
        game:clicked(page:_getDB($gameID)/game, xs:integer($houseId))
        )
};

declare 
%rest:path("gamestate/{$dbID}")
function page:gamestate($dbID)
{
    page:_getDB($dbID)
};

declare
%rest:path("getstatic/{$gameID}")
%rest:GET
function page:getStatic($gameID)
{
    copy $doc := doc("./static/Static.xml")
    modify (
     replace value of node $doc/doc/xsl:stylesheet/xsl:variable[@name = 'GameState']/@select with concat ("document('http://localhost:8984/gamestate/", $gameID,"')")
    ) 
    return $doc
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
    ( db:output(page:_redirect("/db/create")))
};


declare
%rest:path("tryagain/{$dbID}")
%rest:GET
updating function page:tryAgain($dbID)
{
    let $db := page:_getDB($dbID)
    return
        (db:output(page:_redirect(concat("/game/",$dbID))),
        game:resetGame($db/game))
};



(: creates a new game and inserts the game id :)
declare
%rest:path("db/create")
%rest:GET
updating function page:createDB()
{
    let $games := db:open("games")
    let $lastID := page:_lastGameID()  
    let $nextID := xs:integer($lastID + 1)
    let $path := concat("/game/",$nextID)
    let $db := page:_gamestateWithNewID($nextID)
    
    return
        (
        page:_addNewGame(<gameid>{$nextID}</gameid>, $games),
        db:output(page:_redirect($path)),
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
        db:output(page:_redirect("/")),
        db:create("games", $db, "games.xml")
        )
};


(:-------------------------------------:)
(:Private methods:)

declare function page:_redirect($redirect as xs:string) as element(restxq:redirect)
{
    <restxq:redirect>{$redirect}</restxq:redirect>
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

declare function page:_getDB($dbID)
{
    let $db := db:open(concat("game-",$dbID))
    return
        $db
};

declare function page:_gamestateWithNewID($nextID)
{
    copy $db := doc("./static/initial_gamestate.xml")
    
    modify (
     replace value of node $db/game/gameid with $nextID
    )
    return $db
};
