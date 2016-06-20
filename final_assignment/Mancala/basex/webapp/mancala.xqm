module namespace page = 'http://basex.org/modules/web-page';

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
    let $db := <mancala>here is mancala data</mancala>
    return
        db:create("mancala-db", $db, "mancala-db.xml")
};


