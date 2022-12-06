# HMI Widgets
This project started on the small collection of flutter widgets 
wich was build for indastrial application. 

## Features
### - State indicators
    - Simple color state indicator
    - Icon color state indicator
### - Progress indicators
    - Linear
    - Circular
### Buttons

### Edit fields

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
Column(
    children: [
        StatusIndicatorWidget(
            width: 150.0,
            indicator: BoolColorIndicator(
                // iconData: Icons.account_tree_outlined,
                stream: Stream<DsDataPoint<bool>>,
            ), 
            caption: const Text('Constant tension')),
        ),
        TextIndicatorWidget(
            width: 150.0 - 22.0,
            indicator: TextIndicator(
                stream: Stream<DsDataPoint<int>>,
                valueUnit: '%',
            ),
            caption: Text(
                'Tension factor',
                style: Theme.of(context).textTheme.bodySmall,
            ),
            alignment: Alignment.topRight, 
        ),
    ],
)
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
