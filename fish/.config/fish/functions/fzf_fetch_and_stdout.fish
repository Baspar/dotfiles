#!/usr/bin/env fish
function fzf_fetch_and_stdout
  set TMP_DATA $argv[1]
  set TMP_INDEX $argv[2]
  set DELTA $argv[3]
  set CMD $argv[4]
  set INDEX $argv[5]
  [ $INDEX ] || set INDEX (cat $TMP_INDEX)

  if ! [ -s $TMP_DATA ]
    eval $CMD | tee $TMP_DATA > /dev/null
  end

  set DATA (cat $TMP_DATA)
  set HEADERS (cat $TMP_DATA | HEAD -n 1 | sed 's/ \{2,\}/|/g' | string split '|')
  set NB_HEADERS (count $HEADERS)

  if [ $DELTA = "+1" ]
    set INDEX (math "$INDEX % $NB_HEADERS + 1")
  else if [ $DELTA = "-1" ]
    set INDEX (math "($INDEX + $NB_HEADERS - 2) % $NB_HEADERS + 1")
  end
  echo $INDEX | tee $TMP_INDEX > /dev/null

  set HEADER "$HEADERS[$INDEX]"
  set REPLACEMENT (printf '\e[91m')'&'(printf '\e[0m')
  # set REPLACEMENT (printf '\e[1m')'&'(printf '\e[0m')

  echo -e $DATA"\n" \
    | sed 's/^ //' \
    | sed "1 s/ $HEADER /$REPLACEMENT/; 1 s/^$HEADER /$REPLACEMENT/; 1 s/ $HEADER\$/$REPLACEMENT/;"
end
