// Copyright (C) 2023 kaxori.
// Use of this source code is governed by an MIT-style license
// that can be found in the LICENSE file.

/**
ActionRepeater

Repeats an action after defined timeout period.
*/
class ActionRepeater:
  isActivated_/bool := false    /// true if repetition has been activated
  timeout_/int := 0             /// time between repetitions in ms
  action_/Lambda := ?           /// action to be performed 
  count_/int := 0               /// action call count
  repeaterTask_/Task? := null
  
  /** creates an repeater object, the repetion is not started automatically. */
  constructor --action/Lambda --timeout_ms --activate/bool=false:
    action_ = action
    isActivated_ = activate
    if isActivated_ and (timeout_ms <= 0): throw "timeout should be greater than 0"
    timeout_ = timeout_ms

  /** forces a manually triggered action, repetition starts if activated */
  trigger: 
    call_
    restartRepeater_

  /** starts, activates the action trigger and repetition.
  Optionally the timeout value can be set */
  start timeout_ms/int=null:
    if timeout_ms:
      if timeout_ms <= 0: throw "timeout should be greater than 0"
      timeout_ = timeout_ms

    isActivated_ = true
    trigger
  
  /** Sets the timeout and activates the repetition */
  repeat --timeout_ms/int:
    if timeout_ms <= 0: throw "timeout should be greater than 0"
    timeout_ = timeout_ms
    isActivated_ = true
    restartRepeater_

  /** Stops and deactivates the repetition */
  stop: 
    isActivated_ = false
    stopRepeater_

  /** Returns the number of triggered or repeated action calls */
  count->int: return count_

  /** Triggers the action and re-starts the repeater. */
  call_:
    count_++
    action_.call
    restartRepeater_

  restartRepeater_:
    stopRepeater_
    if isActivated_: 
      startRepeater_

  startRepeater_:
    repeaterTask_ = task :: 
      sleep --ms=timeout_
      call_

  stopRepeater_: 
    if repeaterTask_: 
      repeaterTask_.cancel