import actionRepeater show *

/**

to execute it on host:
'jag run simple.toit -d host'
*/

STEP_DELAY ::= 10_000
startTime := ?

dtStr-> string:
  return "$(%6.1f (Duration.since startTime).in_ms/1000.0)s :"


main:
  print "\n\n\nTest of ActionRepeater\n"
  count := 0
  startTime = Time.now

  action := ActionRepeater --timeout_ms=1_000 --action=::
    ++count
    print  dtStr + "action code called #$count"

  sleep --ms=1000

  action.start --timeout_ms=200 --triggerAtStart=true
  sleep --ms=1000
  
  action.start --timeout_ms=2000
  sleep --ms=STEP_DELAY

  action.stop
  sleep --ms=STEP_DELAY

  action.trigger
  action.trigger
