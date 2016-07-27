module namespace players = "players";

(: players class :)

(:-------------------------------------:)
(:Public methods:)

declare updating function players:setNextPlayerWithId($this, $id)
{
    replace value of node $this/turn
        with $id
};


declare function players:currentPlayer($this)
{
    let $turnId := $this/turn
    for $player in $this/player
    where $player/id = $turnId
    return
        $player
};


declare updating function players:toggleCurrentPlayer($this)
{
    players:_setNextPlayer($this,
    if (players:currentPlayer($this)/id = 1) then
        $this/player[2]
    else
        $this/player[1])
};

declare function players:storeIdForCurrentPlayer($this)
{
    let $x := 1
    return ( if(players:currentPlayer($this)/id = 1) then
        7
    else
        14 )
};

(:-------------------------------------:)
(:Private methods:)

declare updating function players:_setNextPlayer($this, $nextPlayer)
{
    replace value of node $this/turn
        with $nextPlayer/id
};

