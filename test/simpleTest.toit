/**
TOIT.DOC
test doc ...
*/

import log
import ..src.action_repeater show *
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
  //log.set_default (log.default.with_level 0)
  //logger := log.default
  log.set_default (log.default.with_level log.FATAL_LEVEL)
  logger := log.default

  count := 0
  startTime = Time.now

  action := ActionRepeater
      --label="action" 
      --timespan_ms=2_000 
      --action=::
          ++count
          print  dtStr + "action code called #$count"

  expect action.count == 0
  print dtStr + "created"
  delay
  expect action.count == 0

  print dtStr + "1st trigger"
  action.start --timespan_ms=1000 --triggerAtStart
  delay
  expect action.count == 10

  print dtStr + "stop"
  action.stop
  delay
  expect action.count == 10


  print dtStr + "timeout=2000"
  action.repeat --timespan_ms=2000
  delay
  expect 10 < action.count < 15


  action.stop
  action.trigger
  print dtStr + "trigger"
  delay
  expect action.count == 15

  print dtStr + "test successfully passed"
  sleep --ms=5