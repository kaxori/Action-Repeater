// Copyright (C) 2023 kaxori.
// Use of this source code is governed by an MIT-style license
// that can be found in the LICENSE file.

/**
ActionRepeater
Automatically repeats an action after an specified period of time.

# ToitDoc
*Action* is the program code, addressed by a lambda function, that is to be executed.
An action can be also triggered manually at any time. The repeat time is then reset. 
*Timespan* is the amount of time after which auto-repeat is triggered.

*/

import log

/*
Implementation class ActionRepeater

How does it work ?

A repeaterTask is created
*/
class ActionRepeater:
  
  isActivated_ /bool := false    /// true if repetition has been activated
  timespan_ /int := 0                /// time between repetitions in ms
  action_ /Lambda                /// action to be performed 
  repeaterTask_/Task? := null
  count_/int := 0               /// action call count
  logger_ /log.Logger           /// logging 
  label_ /string                /// object ID (i.e. for log info) 
  

  /** creates an repeater object, the repetion is not actived by default. */
  constructor 
      --label/string = "? unlabeled"
      --action/Lambda
      --timespan_ms/int 
      --activate/bool=false:


    logger_ = log.default.with_name "action repeater"

    label_ = label
    action_ = action
    isActivated_ = activate

    if timespan_ms < 5:
      logger_.info "\"$label\": timespan $timespan_ms ms is very short !"
    timespan_ = timespan_ms

    if isActivated_ and (timespan_ms <= 0): throw "timeout should be greater than 0"

    logger_.info "\"$label_\" constructed"

  /** manually triggers the action, repetition starts if activated */
  trigger: 
    logger_.info "\"$label_\" manual trigger"
    call_ --manuallyTriggered=true
    restartRepeater_

  /** activates the timeout repetition. A trigger is immediately released if triggerAtStart is set true.
  Optionally the timeout value can be set */
  start --triggerAtStart/bool?=false --timespan_ms/int?=null:
    if timespan_ms != null:
      if timespan_ms <= 0: throw "timeout should be greater than 0"
      timespan_ = timespan_ms

    isActivated_ = true
    if triggerAtStart: trigger
    restartRepeater_
  
  /** Sets the timeout and activates the repetition. */
  repeat --timespan_ms/int=null:
    if timespan_ms != null:
      if timespan_ms <= 0: throw "timeout should be greater than 0"
      timespan_ = timespan_ms
    isActivated_ = true
    restartRepeater_

  /** Stops and deactivates the repetition */
  stop: 
    isActivated_ = false
    stopRepeater_
    logger_.info "\"$label_\" repeater stopped"

  /** Returns the number of triggered or repeated action calls */
  count->int: return count_

  /** starts a task and sleeps/wait for the timespan, than the action repetition is triggered */
  startRepeater_:
    repeaterTask_ = task :: 
      sleep --ms=timespan_
      logger_.info "\"$label_\" repetition triggered"
      call_ --manuallyTriggered=false

  /** Triggers the action and re-starts the repeater. 
  The optional parameter indicates a manual trigger.*/
  call_ --manuallyTriggered/bool=false:
    count_++
    action_.call manuallyTriggered
    restartRepeater_

  
  restartRepeater_:
    stopRepeater_
    if isActivated_: 
      startRepeater_

  stopRepeater_: 
    if repeaterTask_: 
      repeaterTask_.cancel