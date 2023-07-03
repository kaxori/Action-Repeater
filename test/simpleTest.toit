/**
TOIT.DOC
test doc ...
*/


import ..src.actionRepeater show *
import expect show *

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

  expect action.count == 0
  print dtStr + "created"
  delay
  expect action.count == 0

  print dtStr + "1st trigger"
  action.start --timeout_ms=1000 --triggerAtStart
  delay
  expect action.count == 10

  print dtStr + "stop"
  action.stop
  delay
  expect action.count == 10

  print dtStr + "timeout=1000"
  action.repeat --timeout_ms=500
  delay
  expect 10 < action.count <= 30

  action.stop
  action.trigger
  print dtStr + "trigger"
  delay
  expect action.count == 30

  print dtStr + "test successfully passed"
  sleep --ms=5