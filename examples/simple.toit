//import action_repeater show *
import ..src.action_repeater show *
import log

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
  log.set_default (log.default.with_level log.FATAL_LEVEL)
  logger := log.default
  
  action := ActionRepeater --label="test" 
    --timespan_ms=1_000 
    --action= :: | flagManualTrigger |
      ++count
      trigger := flagManualTrigger?"==> MANUAL":""
      print dtStr + "action code called #$count $(trigger)"

  sleep --ms=1000

  action.start --timespan_ms=200 --triggerAtStart=true
  sleep --ms=1000
  
  action.start --timespan_ms=2000
  sleep --ms=STEP_DELAY

  action.stop
  sleep --ms=STEP_DELAY

  action.trigger
  action.trigger
