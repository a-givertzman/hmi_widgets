import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/indicators/status_indicators/dps_icon_indicator.dart';
import 'package:hmi_widgets/src/indicators/status_indicators/invalid_status_indicator.dart';
import 'package:hmi_widgets/src/indicators/status_indicators/status_indicator_widget.dart';
import 'package:hmi_widgets/src/theme/app_theme.dart';

class AcDriveWidget extends StatelessWidget {
  final Stream<DsDataPoint<int>>? _stream;
  final String? _caption;
  final bool _disabled;
  final Widget? _acMotorIcon;
  final Widget? _acMotorFailureIcon;
  ///
  const AcDriveWidget({
    Key? key,
    Widget? acMotorIcon,
    Widget? acMotorFailureIcon,
    Stream<DsDataPoint<int>>? stream,
    String? caption,
    bool disabled = false,
  }) : 
    _stream = stream,
    _caption = caption,
    _disabled = disabled,
    _acMotorIcon = acMotorIcon,
    _acMotorFailureIcon = acMotorFailureIcon,
    super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    final iconsRootDir = 'assets/icons';
    final acMotorIcon = _acMotorIcon ?? Image(
      image: AssetImage(
        '$iconsRootDir/ac_motor.png',
        package: 'hmi_widgets',
      ),
    );
    final acMotorFailureIcon = _acMotorFailureIcon ?? Image(
      image: AssetImage(
        '$iconsRootDir/ac_motor_failure.png',
        package: 'hmi_widgets',
      ),
    );
    final caption = _caption;
    final stateColors = Theme.of(context).stateColors;
    return InvalidStatusIndicator(
      stream: _stream,
      stateColors: stateColors,
      child: StatusIndicatorWidget(
        width: 100,
        height: 100,
        disabled: _disabled,
        indicator: DpsIconIndicator(
          stream: _stream,
          posUndefinedIcon: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Theme.of(context).stateColors.invalid,
              BlendMode.srcIn,
            ), 
            child: acMotorIcon,
          ),
          posOffIcon: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Theme.of(context).stateColors.off,
              BlendMode.srcIn,
            ), 
            child: acMotorIcon,
          ),
          posOnIcon: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Theme.of(context).stateColors.on,
              BlendMode.srcIn,
            ), 
            child: acMotorIcon,
          ),
          posTransientIcon: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Theme.of(context).stateColors.error,
              BlendMode.srcIn,
            ), 
            child: acMotorFailureIcon,
          ),
        ), 
        caption: (caption != null) 
          ? Text(caption, textAlign: TextAlign.center) 
          : null,
        alignment: Alignment.center,
      ),
    );
  }
}