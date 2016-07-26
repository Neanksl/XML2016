module namespace store = "store";


(: store class :)

(:-------------------------------------:)
(:Public methods:)

declare updating function store:incSeedCount($this, $amount)
{
    replace value of node $this
        with $this + $amount
};

declare updating function store:setSeedCount($this, $amount)
{
    replace value of node $this
        with $amount
};

declare function store:seedCount($this)
as xs:integer
{
    let $this := $this
    return
        $this
};