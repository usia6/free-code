The `Microcontroller` with the code attached in [`./Script.luau`](https://github.com/usia6/free-code/blob/main/Doors/KeyLockDoor/Script.luau) must directly contact a `Disk`,a door, with it's material configured in
the header of the previously mentioned script file. It must also directly contact at least 1 `TouchScreen`, however, it supports an infinite
amount of them.

Before starting, you must attach a `Microcontroller` to the previously mentioned `Disk`, and run the code included in
[`./WritableInterface.luau`](https://github.com/usia6/free-code/blob/main/Doors/KeyLockDoor/WritableInterface.luau). After doing so, you may remove the extra `Microcontroller`

Obviously, you must provide power to both the `Microcontroller` and the `TouchScreen`s for the door to actually run.

An example model is included in [`./ExampleModel.json`](https://github.com/usia6/free-code/blob/main/Doors/KeyLockDoor/ExampleModel.json).
