# Day 8 - State & Lifting State Up

## Topics Covered

* State
* StatefulWidget
* setState()
* Lifting State Up
* Passing data from parent to child
* Passing callbacks from parent to child
* VoidCallback
* StatelessWidget
* @override

## Practice

Created a counter application where:

* `CounterScreen` owns the counter state.
* `CounterDisplay` receives and displays the counter.
* `CounterButton` receives a callback to increment the counter.
* `setState()` updates the counter and rebuilds the UI.

## Goal

Understand how state can be moved to a common parent and shared with child widgets using data and callbacks.

