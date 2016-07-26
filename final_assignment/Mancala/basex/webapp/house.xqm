module namespace house = "house";


(: house class :)

(:-------------------------------------:)
(:Public methods:)

declare function house:seedCount($this)
as xs:integer
{
    let $this := $this
    return
        $this
};

declare updating function house:setSeedCount($this, $count)
{
    replace value of node $this
        with $count
};


declare updating function house:incSeedCount($this, $amount)
{
    replace value of node $this
        with $this + $amount
};

(:-------------------------------------:)
(:Private methods:)

