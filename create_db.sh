#!/bin/bash
echo "Creating database."
mkdir -p data/
chmod 777 data
rm data/db.sqlite
cat vendor/sabre/dav/examples/sql/sqlite.* | sqlite3 data/db.sqlite
chmod 666 data/db.sqlite

echo "Creating principals"


function create_user() {
    userstring=$1
    displayName=$2
    email="$userstring@example.com"

    echo "Creating user $userstring"

    # User
    digest=`echo -n "$userstring:SabreDAV:$userstring" | md5`
    sql="INSERT INTO users (username, digesta1) VALUES ('$userstring','$digest');"
    echo $sql | sqlite3 data/db.sqlite

    # Principal
    sql="INSERT INTO principals (uri, email, displayname) VALUES ('principals/$userstring', '$email', '$displayName');"
    echo $sql | sqlite3 data/db.sqlite

    # Default calendar
    sql="INSERT INTO calendars (principaluri, displayname, uri, synctoken, components) VALUES ('principals/$userstring', 'Calendar', 'calendar', '1', 'VEVENT');"
    echo $sql | sqlite3 data/db.sqlite

    # Default tasks lsit
    sql="INSERT INTO calendars (principaluri, displayname, uri, synctoken, components) VALUES ('principals/$userstring', 'Tasks', 'tasks', '1', 'VTODO');"
    echo $sql | sqlite3 data/db.sqlite

}

for i in $(seq -f "%02g" 1 40)
do
    create_user "user$i" "User $i"
done
for i in $(seq -f "%02g" 1 10)
do
    create_user "public$i" "Public $i"
done
for i in $(seq -f "%02g" 1 20)
do
    create_user "resource$i" "Resource $i"
done
for i in $(seq -f "%02g" 1 10)
do
    create_user "location$i" "Location $i"
done
for i in $(seq -f "%02g" 1 40)
do
    create_user "group$i" "Group $i"
done
