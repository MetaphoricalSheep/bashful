#!/usr/bin/env bats

. "$BATS_TEST_DIRNAME"/../unabashed.sh

#------------------------------------------------helpers.is_number------------------------------------------------------------------

@test "check that \`append_file\` returns 1" {
  run append_file
  [ $status = 1 ]
}


@test "check that \`append_file\` /tmp/tlotr_prologue.bats returns 1" {
  run append_file /tmp/tlotr_prologue.bats
  [ $status = 1 ]
}


@test "check that \`append_file\` /tmp/tlotr_prologue123123.bats \"test text\" returns 1" {
  run append_file /tmp/tlotr_prologue123123.bats "test text"
  [ $status = 1 ]
}


@test "check that \`append_file\` /tmp/tlotr_prologue.bats "{...}" 7 returns 0" {
  local _file
  local _data
  local _expected_hash
  local _calculated_hash

  _file=/tmp/tlotr_prologue.bats

  cat << prologue > "$_file"
ThiS book is largely concerned with Hobbits, and from its pages 
a reader may discover much of their character and a little of 
their history. Further information will also be found in the 
published, under the title of The Hobbit. That story was derived 
from the earlier chapters of the Red Book, composed by Bilbo 
himself, the first Hobbit to become famous in the world at 
large, and called by him There and Back again, since they told 
of his journey into the East and his return: an adventure which 
later involved all the Hobbits in the great events of that Age 
that are here related.
prologue
    
  _data="selection from the Red Book of Westmarch that has already been"
  _expected_hash="f626d1cf3059a822af7fb7e31a2c7f27b54b9a77"

  run append_file "$_file" "$_data" 7

  _calculated_hash=$(shasum /tmp/tlotr_prologue.bats | awk "{ print \$1 }")
  rm "$_file"

  [ $status = 0 ]
  [ $_expected_hash = $_calculated_hash ]
}


@test "check that \`append_file\` /tmp/tlotr_prologue.bats "{...}" returns 1" {
  local _file
  local _data
  local _expected_hash
  local _calculated_hash

  _file=/tmp/tlotr_prologue.bats

  cat << prologue > "$_file"
ThiS book is largely concerned with Hobbits, and from its pages 
a reader may discover much of their character and a little of 
their history. Further information will also be found in the 
published, under the title of The Hobbit. That story was derived 
from the earlier chapters of the Red Book, composed by Bilbo 
himself, the first Hobbit to become famous in the world at 
large, and called by him There and Back again, since they told 
of his journey into the East and his return: an adventure which 
later involved all the Hobbits in the great events of that Age 
that are here related.
prologue
    
  _data="selection from the Red Book of Westmarch that has already been"
  _expected_hash="f626d1cf3059a822af7fb7e31a2c7f27b54b9a77"

  run append_file "$_file" "$_data"

  _calculated_hash=$(shasum /tmp/tlotr_prologue.bats | awk "{ print \$1 }")
  rm "$_file"

  [ $status = 0 ]
  [ $_expected_hash != $_calculated_hash ]
}
