# Theme
A set of utilities for working with application theme.

## AppThemeData

Contains colors used to indicate current state of data contained in widgets.

| **Color**        | **Used for...**                                          | **HMI Widgets API**                      | **Comment**                                                                     |
| :--------------- | :------------------------------------------------------- | :--------------------------------------- | :------------------------------------------------------------------------------ |
| **State Colors** |                                                          |                                          |                                                                                 |
| Error            | indication of application or infrastructure error.       | `<ThemeData>.stateColors.error`          | E.g., an error when querying database or API.                                   |
| Alarm            | indication of `DsDataPoint` with non-zero Alarm Class.   | `<ThemeData>.stateColors.alarm`          | Infrastructure incident or warning.                                             |
| Obsolete         | indication of `DsDataPoint` with obsolete Status.        | `<ThemeData>.stateColors.obsolete`       | Cached or outdated data from last session.                                      |
| Invalid          | indication of `DsDataPoint` with invalid Status.         | `<ThemeData>.stateColors.invalid`        | Inaccurate data due to communication failure.                                   |
| Time invalid     | indication of `DsDataPoint` with timeInvalid Status.     | `<ThemeData>.stateColors.timeInvalid`    | Data with invalid time stamp: signal source does not have time synchronization. |
| Low level        | indication of low metric values.                         | `<ThemeData>.stateColors.lowLevel`       | -                                                                               |
| Alarm low level  | indication of abnormally low metric values.              | `<ThemeData>.stateColors.alarmLowLevel`  | -                                                                               |
| High level       | indication of high metric values.                        | `<ThemeData>.stateColors.highLevel`      | -                                                                               |
| Alarm high level | indication of abnormally high metric values.             | `<ThemeData>.stateColors.alarmHighLevel` | -                                                                               |
| Off              | indication that something is turned off.                 | `<ThemeData>.stateColors.off`            | Object is turned off or is in passive state (idle).                             |
| On               | indication that something is turned on.                  | `<ThemeData>.stateColors.on`             | Object is turned on or is in active state (doing some work).                    |
| **Alarm Colors** |                                                          |                                          |                                                                                 |
| Class 1          | indication of `DsDataPoint` with Alarm Class equal to 1. | `<ThemeData>.alarmColors.class1`         | Emergency Alarm (state when equipment can't work anymore).                      |
| Class 2          | indication of `DsDataPoint` with Alarm Class equal to 2. | `<ThemeData>.alarmColors.class2`         | Not in use (subclass of Emergency Alarm).                                       |
| Class 3          | indication of `DsDataPoint` with Alarm Class equal to 3. | `<ThemeData>.alarmColors.class3`         | Not in use (subclass of Emergency Alarm).                                       |
| Class 4          | indication of `DsDataPoint` with Alarm Class equal to 4. | `<ThemeData>.alarmColors.class4`         | Warning (important events to pay attention).                                    |
| Class 5          | indication of `DsDataPoint` with Alarm Class equal to 5. | `<ThemeData>.alarmColors.class5`         | Not in use.                                                                     |
| Class 6          | indication of `DsDataPoint` with Alarm Class equal to 6. | `<ThemeData>.alarmColors.class6`         | Not in use.                                                                     |