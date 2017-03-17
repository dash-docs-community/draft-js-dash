# clean up previous remains, if any
rm -rf Contents/Resources
rm -rf DraftJS.docset
mkdir -p Contents/Resources/Documents

# create a fresh sqlite db
cd Contents/Resources
sqlite3 docSet.dsidx 'CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT)'
sqlite3 docSet.dsidx 'CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path)'

# fetch the whole doc site
cd Documents
wget -m -p -E -k -np https://draftjs.org/

# move it around a bit
mv draftjs.org ./draft-js
cd ../../../

# create data file from base index page
node src/createSectionJSON.js

# change the documentation markup layout a bit to fit dash's small window
node src/modifyDocsHTML.js

# read the previously fetched doc site and parse it into sqlite
node src/index.js

# bundle up!
mkdir DraftJS.docset
cp -r Contents DraftJS.docset
cp src/icon* DraftJS.docset

# Create gzip bundle for Dash Contribution
tar --exclude='.DS_Store' -cvzf DraftJS.tgz DraftJS.docset

