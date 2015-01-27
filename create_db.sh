#!/bin/bash
echo "Creating database."
mkdir -p data/
chmod 777 data
rm data/db.sqlite
cat vendor/sabre/dav/examples/sql/sqlite.* | sqlite3 data/db.sqlite
chmod 666 data/db.sqlite

echo "Creating principals"

for i in $(seq -f "%02g" 1 40)
do
    # User
    digest=`echo -n "user$i:SabreDAV:user$i" | md5`
    sql="INSERT INTO users (username, digesta1) VALUES ('user$i','$digest');"
    echo $sql | sqlite3 data/db.sqlite

    # Principal

    sql="INSERT INTO principals (uri, email, displayname) VALUES ('principals/user$i', 'user$i@example.com', 'User $i');"
    echo $sql | sqlite3 data/db.sqlite

    # Default calendar
    sql="INSERT INTO calendars (principaluri, displayname, uri, synctoken, components) VALUES ('principals/user$i', 'Calendar', 'calendar', '1', 'VEVENT');"
    echo $sql | sqlite3 data/db.sqlite

    # Default tasks lsit
    sql="INSERT INTO calendars (principaluri, displayname, uri, synctoken, components) VALUES ('principals/user$i', 'Tasks', 'tasks', '1', 'VTODO');"
    echo $sql | sqlite3 data/db.sqlite

done
