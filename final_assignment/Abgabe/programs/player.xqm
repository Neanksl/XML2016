module namespace player = "player";

(: player class :)

(:-------------------------------------:)
(:Public methods:)

declare updating function player:increaseWinCount($this)
{
    replace value of node $this/winCount
        with $this/winCount + 1
};

(: currently unused 
declare updating function player:resetWinCount($this)
{
    replace value of node $this/winCount
        with 0
};
:)

(:-------------------------------------:)
(:Private methods:)
