#!/bin/bash
rm -f *.xml
for filename in *.008 
do
  echo "$filename"
  bash create_adddoc4.sh $filename
  if [ -e $filename.xml ]
    then
  curl http://localhost:8983/solr/collection1/update -H "Content-Type: text/xml" --data @$filename.xml
  rm $filename.xml
  fi
done

curl http://localhost:8983/solr/collection1/update --data '<commit/>' -H 'Content-type:text/xml; charset=utf-8'

#curl http://127.0.0.1:8983/solr/update?commit=true -H "Content-Type: text/xml" --data @finish.xml
