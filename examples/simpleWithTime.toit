import actionRepeater show *

STEP_DELAY ::= 10_000
startTime := ?

dtStr-> string:
  return "$(%6.1f (Duration.since startTime).in_ms/1000.0)s :"

delay:
  print  dtStr + "sleep $STEP_DELAY\n"
  sleep --ms=STEP_DELAY


main:
  print "\n\n\nTest of ActionRepeater\n"
  count := 0
  startTime = Time.now

  action := ActionRepeater --timeout_ms=2_000 --action=::
    ++count
    print  dtStr + "action code called #$count"

  print dtStr + "created"
  delay

  print dtStr + "1st trigger"
  action.start 200
  delay

  print dtStr + "timeout=1000"
  action.repeat --timeout_ms=1000
  delay

  print dtStr + "stop"
  action.stop
  delay

  print dtStr + "trigger"
  action.trigger
  delay

  print dtStr + "end"
  sleep --ms=5