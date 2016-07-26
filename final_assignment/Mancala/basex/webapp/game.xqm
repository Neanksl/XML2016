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

declare updating function game:checkForGameFinished($this)
{
    if (board:isRowEmpty($this/board, "top")) then
        (store:setSeedCount(
            board:getStoreWithId($this/board, 14),
            (: store + sum of top row:)
            board:sumOfStoreAndRow($this/board, "bottom")),
        board:clearHouses($this/board,"bottom"),
        game:_UpdateWinner($this))    
    else
        (if (board:isRowEmpty($this/board, "bottom")) then
            (board:clearHouses($this/board,"top"),
                store:setSeedCount(
                    board:getStoreWithId($this/board, 7), 
            
                    (: store + sum of top row :)
                    board:sumOfStoreAndRow($this/board, "top")),
            game:_UpdateWinner($this)
            )
        else ())
};

declare updating function game:resetGame($this)
{
    game:_resetBoard($this/board, 4),
    players:setNextPlayerWithId($this/players, 1),
    replace value of node $this/wonBy with 0
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



declare updating function game:_UpdateWinner($this)
{
        if (board:sumOfStoreAndRow($this/board, "top") > board:sumOfStoreAndRow($this/board, "bottom") ) then
            (replace value of node $this/wonBy
                with 1, 
                player:increaseWinCount($this/players/player[1])
                )
        else
            (replace value of node $this/wonBy
                with 2,
                player:increaseWinCount($this/players/player[2])
                )
    
};


(: Logging method for debugging :)
declare updating function game:log($game, $message)
{
    replace value of node $game/logMessage with $message
};