module namespace game = "game";

import module namespace board = 'board' at 'board.xqm';
import module namespace players = 'players' at 'players.xqm';
import module namespace player = 'player' at 'player.xqm';
import module namespace store = 'store' at 'store.xqm';

(: game class :)

(:-------------------------------------:)
(:Public methods:)

declare updating function game:clicked($this, $id)
{
    board:clickedHouse($this/board, xs:integer($id), $this)
};

declare updating function game:checkForFinished($this, $gamesDB)
{
    if (board:isRowEmpty($this/board, "top")) then
        (store:setSeedCount(
        board:storeWithId($this/board, 14),
        (: store + sum of top row:)
        board:sumOfStoreAndRow($this/board, "bottom")),
        board:clearHouses($this/board, "bottom"),
        game:_updateWinner($this, $gamesDB))
    else
        (if (board:isRowEmpty($this/board, "bottom")) then
            (board:clearHouses($this/board, "top"),
            store:setSeedCount(
            board:storeWithId($this/board, 7),
            
            (: store + sum of top row :)
            board:sumOfStoreAndRow($this/board, "top")),
            game:_updateWinner($this, $gamesDB)
            )
        else
            ())
};

declare updating function game:reset($this)
{
    game:_resetBoard($this/board, 4),
    players:setNextPlayerWithId($this/players, 1),
    replace value of node $this/wonBy
        with 0
};


(:-------------------------------------:)
(:Private methods:)

declare updating function game:_resetBoard($this, $startSeeds)
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


declare updating function game:_updateWinner($this, $gamesDB)
{
    if (board:sumOfStoreAndRow($this/board, "top") > board:sumOfStoreAndRow($this/board, "bottom")) then
        (
        replace value of node $this/wonBy
            with 1,
        player:increaseWinCount($this/players/player[1]),
        game:_updateWinnerLoser($this, $gamesDB, board:sumOfStoreAndRow($this/board, "top"), board:sumOfStoreAndRow($this/board, "bottom"))
        )
    else
        (replace value of node $this/wonBy
            with 2,
        player:increaseWinCount($this/players/player[2]),
        game:_updateWinnerLoser($this, $gamesDB, board:sumOfStoreAndRow($this/board, "bottom"), board:sumOfStoreAndRow($this/board, "top"))
        )
};


declare updating function game:_updateWinnerLoser($this, $gamesDB, $winner, $loser)
{
    replace value of node $gamesDB/databases/gameid[text() = $this/gameid/text()]/@winner
        with $winner,
    replace value of node $gamesDB/databases/gameid[text() = $this/gameid/text()]/@loser
        with $loser
};


(: Logging method for debugging :)
declare updating function game:log($game, $message)
{
    replace value of node $game/logMessage
        with $message
};
