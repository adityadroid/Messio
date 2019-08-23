import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:messio/config/Styles.dart';

/// Created by Marcin Szałek

///NumberPicker is a widget designed to pick a number between #minValue and #maxValue
class NumberPicker extends StatelessWidget {
  ///height of every list element for normal number picker
  ///width of every list element for horizontal number picker
  static const double kDefaultItemExtent = 50.0;

  ///width of list view for normal number picker
  ///height of list view for horizontal number picker
  static const double kDefaultListViewCrossAxisSize = 100.0;

  ///constructor for horizontal number picker
  NumberPicker.horizontal({
    Key key,
    @required int initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    this.itemExtent = kDefaultItemExtent,
    this.listViewHeight = kDefaultListViewCrossAxisSize,
    this.step = 1,
    this.zeroPad = false,
    this.highlightSelectedValue = true,
    this.decoration,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedIntValue = initialValue,
        selectedDecimalValue = -1,
        decimalPlaces = 0,
        intScrollController = new ScrollController(
          initialScrollOffset: (initialValue - minValue) ~/ step * itemExtent,
        ),
        scrollDirection = Axis.horizontal,
        decimalScrollController = null,
        listViewWidth = 3 * itemExtent,
        infiniteLoop = false,
        integerItemCount = (maxValue - minValue) ~/ step + 1,
        super(key: key);

  ///constructor for integer number picker
  NumberPicker.integer({
    Key key,
    @required int initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    this.itemExtent = kDefaultItemExtent,
    this.listViewWidth = kDefaultListViewCrossAxisSize,
    this.step = 1,
    this.scrollDirection = Axis.vertical,
    this.infiniteLoop = false,
    this.zeroPad = false,
    this.highlightSelectedValue = true,
    this.decoration,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        assert(scrollDirection != null),
        selectedIntValue = initialValue,
        selectedDecimalValue = -1,
        decimalPlaces = 0,
        intScrollController = infiniteLoop
            ? new InfiniteScrollController(
          initialScrollOffset:
          (initialValue - minValue) ~/ step * itemExtent,
        )
            : new ScrollController(
          initialScrollOffset:
          (initialValue - minValue) ~/ step * itemExtent,
        ),
        decimalScrollController = null,
        listViewHeight = 3 * itemExtent,
        integerItemCount = (maxValue - minValue) ~/ step + 1,
        super(key: key);

  ///constructor for decimal number picker
  NumberPicker.decimal({
    Key key,
    @required double initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    this.decimalPlaces = 1,
    this.itemExtent = kDefaultItemExtent,
    this.listViewWidth = kDefaultListViewCrossAxisSize,
    this.highlightSelectedValue = true,
    this.decoration,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(decimalPlaces != null && decimalPlaces > 0),
        assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        selectedIntValue = initialValue.floor(),
        selectedDecimalValue = ((initialValue - initialValue.floorToDouble()) *
            math.pow(10, decimalPlaces))
            .round(),
        intScrollController = new ScrollController(
          initialScrollOffset: (initialValue.floor() - minValue) * itemExtent,
        ),
        decimalScrollController = new ScrollController(
          initialScrollOffset: ((initialValue - initialValue.floorToDouble()) *
              math.pow(10, decimalPlaces))
              .roundToDouble() *
              itemExtent,
        ),
        listViewHeight = 3 * itemExtent,
        step = 1,
        scrollDirection = Axis.vertical,
        integerItemCount = maxValue.floor() - minValue.floor() + 1,
        infiniteLoop = false,
        zeroPad = false,
        super(key: key);

  ///called when selected value changes
  final ValueChanged<num> onChanged;

  ///min value user can pick
  final int minValue;

  ///max value user can pick
  final int maxValue;

  ///inidcates how many decimal places to show
  /// e.g. 0=>[1,2,3...], 1=>[1.0, 1.1, 1.2...]  2=>[1.00, 1.01, 1.02...]
  final int decimalPlaces;

  ///height of every list element in pixels
  final double itemExtent;

  ///height of list view in pixels
  final double listViewHeight;

  ///width of list view in pixels
  final double listViewWidth;

  ///ScrollController used for integer list
  final ScrollController intScrollController;

  ///ScrollController used for decimal list
  final ScrollController decimalScrollController;

  ///Currently selected integer value
  final int selectedIntValue;

  ///Currently selected decimal value
  final int selectedDecimalValue;

  ///If currently selected value should be highlighted
  final bool highlightSelectedValue;

  ///Decoration to apply to central box where the selected value is placed
  final Decoration decoration;

  ///Step between elements. Only for integer datePicker
  ///Examples:
  /// if step is 100 the following elements may be 100, 200, 300...
  /// if min=0, max=6, step=3, then items will be 0, 3 and 6
  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final int step;

  /// Direction of scrolling
  final Axis scrollDirection;

  ///Repeat values infinitely
  final bool infiniteLoop;

  ///Pads displayed integer values up to the length of maxValue
  final bool zeroPad;

  ///Amount of items
  final int integerItemCount;

  //
  //----------------------------- PUBLIC ------------------------------
  //

  /// Used to animate integer number picker to new selected value
  void animateInt(int valueToSelect) {
    int diff = valueToSelect - minValue;
    int index = diff ~/ step;
    animateIntToIndex(index);
  }

  /// Used to animate integer number picker to new selected index
  void animateIntToIndex(int index) {
    _animate(intScrollController, index * itemExtent);
  }

  /// Used to animate decimal part of double value to new selected value
  void animateDecimal(int decimalValue) {
    _animate(decimalScrollController, decimalValue * itemExtent);
  }

  /// Used to animate decimal number picker to selected value
  void animateDecimalAndInteger(double valueToSelect) {
    animateInt(valueToSelect.floor());
    animateDecimal(((valueToSelect - valueToSelect.floorToDouble()) *
        math.pow(10, decimalPlaces))
        .round());
  }

  //
  //----------------------------- VIEWS -----------------------------
  //

  ///main widget
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    if (infiniteLoop) {
      return _integerInfiniteListView(themeData);
    }
    if (decimalPlaces == 0) {
      return _integerListView(themeData);
    } else {
      return new Row(
        children: <Widget>[
          _integerListView(themeData),
          _decimalListView(themeData),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
  }

  Widget _integerListView(ThemeData themeData) {
    TextStyle defaultStyle = Styles.textLight;
    TextStyle selectedStyle = Styles.numberPickerHeading;

    var listItemCount = integerItemCount + 2;

    return Listener(
      onPointerUp: (ev) {
        ///used to detect that user stopped scrolling
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        if (intScrollController.position.activity is HoldScrollActivity) {
          animateInt(selectedIntValue);
        }
      },
      child: new NotificationListener(
        child: new Container(
          height: listViewHeight,
          width: listViewWidth,
          child: Stack(
            children: <Widget>[
              new ListView.builder(
                scrollDirection: scrollDirection,
                controller: intScrollController,
                itemExtent: itemExtent,
                itemCount: listItemCount,
                cacheExtent: _calculateCacheExtent(listItemCount),
                itemBuilder: (BuildContext context, int index) {
                  final int value = _intValueFromIndex(index);

                  //define special style for selected (middle) element
                  final TextStyle itemStyle =
                  value == selectedIntValue && highlightSelectedValue
                      ? selectedStyle
                      : defaultStyle;

                  bool isExtra = index == 0 || index == listItemCount - 1;

                  return isExtra
                      ? new Container() //empty first and last element
                      : new Center(
                    child: new Text(
                      getDisplayedValue(value),
                      style: itemStyle,
                    ),
                  );
                },
              ),
              _NumberPickerSelectedItemDecoration(
                axis: scrollDirection,
                itemExtent: itemExtent,
                decoration: decoration,
              ),
            ],
          ),
        ),
        onNotification: _onIntegerNotification,
      ),
    );
  }

  Widget _decimalListView(ThemeData themeData) {
    TextStyle defaultStyle = themeData.textTheme.body1;
    TextStyle selectedStyle = Styles.numberPickerHeading;

    int decimalItemCount =
    selectedIntValue == maxValue ? 3 : math.pow(10, decimalPlaces) + 2;

    return Listener(
      onPointerUp: (ev) {
        ///used to detect that user stopped scrolling
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        if (decimalScrollController.position.activity is HoldScrollActivity) {
          animateDecimal(selectedDecimalValue);
        }
      },
      child: new NotificationListener(
        child: new Container(
          height: listViewHeight,
          width: listViewWidth,
          child: Stack(
            children: <Widget>[
              new ListView.builder(
                controller: decimalScrollController,
                itemExtent: itemExtent,
                itemCount: decimalItemCount,
                itemBuilder: (BuildContext context, int index) {
                  final int value = index - 1;

                  //define special style for selected (middle) element
                  final TextStyle itemStyle =
                  value == selectedDecimalValue && highlightSelectedValue
                      ? selectedStyle
                      : defaultStyle;

                  bool isExtra = index == 0 || index == decimalItemCount - 1;

                  return isExtra
                      ? new Container() //empty first and last element
                      : new Center(
                    child: new Text(
                        value.toString().padLeft(decimalPlaces, '0'),
                        style: itemStyle),
                  );
                },
              ),
              _NumberPickerSelectedItemDecoration(
                axis: scrollDirection,
                itemExtent: itemExtent,
                decoration: decoration,
              ),
            ],
          ),
        ),
        onNotification: _onDecimalNotification,
      ),
    );
  }

  Widget _integerInfiniteListView(ThemeData themeData) {
    TextStyle defaultStyle = themeData.textTheme.body1;
    TextStyle selectedStyle = Styles.numberPickerHeading;

    return Listener(
      onPointerUp: (ev) {
        ///used to detect that user stopped scrolling
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        if (intScrollController.position.activity is HoldScrollActivity) {
          _animateIntWhenUserStoppedScrolling(selectedIntValue);
        }
      },
      child: new NotificationListener(
        child: new Container(
          height: listViewHeight,
          width: listViewWidth,
          child: Stack(
            children: <Widget>[
              InfiniteListView.builder(
                controller: intScrollController,
                itemExtent: itemExtent,
                itemBuilder: (BuildContext context, int index) {
                  final int value = _intValueFromIndex(index);

                  //define special style for selected (middle) element
                  final TextStyle itemStyle =
                  value == selectedIntValue && highlightSelectedValue
                      ? selectedStyle
                      : defaultStyle;

                  return new Center(
                    child: new Text(
                      getDisplayedValue(value),
                      style: itemStyle,
                    ),
                  );
                },
              ),
              _NumberPickerSelectedItemDecoration(
                axis: scrollDirection,
                itemExtent: itemExtent,
                decoration: decoration,
              ),
            ],
          ),
        ),
        onNotification: _onIntegerNotification,
      ),
    );
  }

  String getDisplayedValue(int value) {
    return zeroPad
        ? value.toString().padLeft(maxValue.toString().length, '0')
        : value.toString();
  }

  //
  // ----------------------------- LOGIC -----------------------------
  //

  int _intValueFromIndex(int index) {
    index--;
    index %= integerItemCount;
    return minValue + index * step;
  }

  bool _onIntegerNotification(Notification notification) {
    if (notification is ScrollNotification) {
      //calculate
      int intIndexOfMiddleElement =
      (notification.metrics.pixels / itemExtent).round();
      if (!infiniteLoop) {
        intIndexOfMiddleElement =
            intIndexOfMiddleElement.clamp(0, integerItemCount - 1);
      }
      int intValueInTheMiddle = _intValueFromIndex(intIndexOfMiddleElement + 1);
      intValueInTheMiddle = _normalizeIntegerMiddleValue(intValueInTheMiddle);

      if (_userStoppedScrolling(notification, intScrollController)) {
        //center selected value
        animateIntToIndex(intIndexOfMiddleElement);
      }

      //update selection
      if (intValueInTheMiddle != selectedIntValue) {
        num newValue;
        if (decimalPlaces == 0) {
          //return integer value
          newValue = (intValueInTheMiddle);
        } else {
          if (intValueInTheMiddle == maxValue) {
            //if new value is maxValue, then return that value and ignore decimal
            newValue = (intValueInTheMiddle.toDouble());
            animateDecimal(0);
          } else {
            //return integer+decimal
            double decimalPart = _toDecimal(selectedDecimalValue);
            newValue = ((intValueInTheMiddle + decimalPart).toDouble());
          }
        }
        onChanged(newValue);
      }
    }
    return true;
  }

  bool _onDecimalNotification(Notification notification) {
    if (notification is ScrollNotification) {
      //calculate middle value
      int indexOfMiddleElement =
          (notification.metrics.pixels + listViewHeight / 2) ~/ itemExtent;
      int decimalValueInTheMiddle = indexOfMiddleElement - 1;
      decimalValueInTheMiddle =
          _normalizeDecimalMiddleValue(decimalValueInTheMiddle);

      if (_userStoppedScrolling(notification, decimalScrollController)) {
        //center selected value
        animateDecimal(decimalValueInTheMiddle);
      }

      //update selection
      if (selectedIntValue != maxValue &&
          decimalValueInTheMiddle != selectedDecimalValue) {
        double decimalPart = _toDecimal(decimalValueInTheMiddle);
        double newValue = ((selectedIntValue + decimalPart).toDouble());
        onChanged(newValue);
      }
    }
    return true;
  }

  ///There was a bug, when if there was small integer range, e.g. from 1 to 5,
  ///When user scrolled to the top, whole listview got displayed.
  ///To prevent this we are calculating cacheExtent by our own so it gets smaller if number of items is smaller
  double _calculateCacheExtent(int itemCount) {
    double cacheExtent = 250.0; //default cache extent
    if ((itemCount - 2) * kDefaultItemExtent <= cacheExtent) {
      cacheExtent = ((itemCount - 3) * kDefaultItemExtent);
    }
    return cacheExtent;
  }

  ///When overscroll occurs on iOS,
  ///we can end up with value not in the range between [minValue] and [maxValue]
  ///To avoid going out of range, we change values out of range to border values.
  int _normalizeMiddleValue(int valueInTheMiddle, int min, int max) {
    return math.max(math.min(valueInTheMiddle, max), min);
  }

  int _normalizeIntegerMiddleValue(int integerValueInTheMiddle) {
    //make sure that max is a multiple of step
    int max = (maxValue ~/ step) * step;
    return _normalizeMiddleValue(integerValueInTheMiddle, minValue, max);
  }

  int _normalizeDecimalMiddleValue(int decimalValueInTheMiddle) {
    return _normalizeMiddleValue(
        decimalValueInTheMiddle, 0, math.pow(10, decimalPlaces) - 1);
  }

  ///indicates if user has stopped scrolling so we can center value in the middle
  bool _userStoppedScrolling(
      Notification notification,
      ScrollController scrollController,
      ) {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    return notification is UserScrollNotification && notification.direction == ScrollDirection.idle && scrollController.position.activity is! HoldScrollActivity;
  }

  /// Allows to find currently selected element index and animate this element
  /// Use it only when user manually stops scrolling in infinite loop
  void _animateIntWhenUserStoppedScrolling(int valueToSelect) {
    // estimated index of currently selected element based on offset and item extent
    int currentlySelectedElementIndex = intScrollController.offset ~/ itemExtent;

    // when more(less) than half of the top(bottom) element is hidden
    // then we should increment(decrement) index in case of positive(negative) offset
    if (intScrollController.offset > 0 &&
        intScrollController.offset % itemExtent > itemExtent / 2) {
      currentlySelectedElementIndex++;
    } else if (intScrollController.offset < 0 &&
        intScrollController.offset % itemExtent < itemExtent / 2) {
      currentlySelectedElementIndex--;
    }

    animateIntToIndex(currentlySelectedElementIndex);
  }

  ///converts integer indicator of decimal value to double
  ///e.g. decimalPlaces = 1, value = 4  >>> result = 0.4
  ///     decimalPlaces = 2, value = 12 >>> result = 0.12
  double _toDecimal(int decimalValueAsInteger) {
    return double.parse((decimalValueAsInteger * math.pow(10, -decimalPlaces))
        .toStringAsFixed(decimalPlaces));
  }

  ///scroll to selected value
  _animate(ScrollController scrollController, double value) {
    scrollController.animateTo(value,
        duration: new Duration(seconds: 1), curve: new ElasticOutCurve());
  }
}

class _NumberPickerSelectedItemDecoration extends StatelessWidget {
  final Axis axis;
  final double itemExtent;
  final Decoration decoration;

  const _NumberPickerSelectedItemDecoration(
      {Key key,
        @required this.axis,
        @required this.itemExtent,
        @required this.decoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new IgnorePointer(
        child: new Container(
          width: isVertical ? double.infinity : itemExtent,
          height: isVertical ? itemExtent : double.infinity,
          decoration: decoration,
        ),
      ),
    );
  }

  bool get isVertical => axis == Axis.vertical;
}

///Returns AlertDialog as a Widget so it is designed to be used in showDialog method
class NumberPickerDialog extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialIntegerValue;
  final double initialDoubleValue;
  final int decimalPlaces;
  final Widget title;
  final EdgeInsets titlePadding;
  final Widget confirmWidget;
  final Widget cancelWidget;
  final int step;
  final bool infiniteLoop;
  final bool zeroPad;
  final bool highlightSelectedValue;
  final Decoration decoration;

  ///constructor for integer values
  NumberPickerDialog.integer({
    @required this.minValue,
    @required this.maxValue,
    @required this.initialIntegerValue,
    this.title,
    this.titlePadding,
    this.step = 1,
    this.infiniteLoop = false,
    this.zeroPad = false,
    this.highlightSelectedValue = true,
    this.decoration,
    Widget confirmWidget,
    Widget cancelWidget,
  })  : confirmWidget = confirmWidget ?? new Text("OK"),
        cancelWidget = cancelWidget ?? new Text("CANCEL"),
        decimalPlaces = 0,
        initialDoubleValue = -1.0;

  ///constructor for decimal values
  NumberPickerDialog.decimal({
    @required this.minValue,
    @required this.maxValue,
    @required this.initialDoubleValue,
    this.decimalPlaces = 1,
    this.title,
    this.titlePadding,
    this.highlightSelectedValue = true,
    this.decoration,
    Widget confirmWidget,
    Widget cancelWidget,
  })  : confirmWidget = confirmWidget ?? new Text("OK"),
        cancelWidget = cancelWidget ?? new Text("CANCEL"),
        initialIntegerValue = -1,
        step = 1,
        infiniteLoop = false,
        zeroPad = false;

  @override
  State<NumberPickerDialog> createState() =>
      new _NumberPickerDialogControllerState(
          initialIntegerValue, initialDoubleValue);
}

class _NumberPickerDialogControllerState extends State<NumberPickerDialog> {
  int selectedIntValue;
  double selectedDoubleValue;

  _NumberPickerDialogControllerState(
      this.selectedIntValue, this.selectedDoubleValue);

  void _handleValueChanged(num value) {
    if (value is int) {
      setState(() => selectedIntValue = value);
    } else {
      setState(() => selectedDoubleValue = value);
    }
  }

  NumberPicker _buildNumberPicker() {
    if (widget.decimalPlaces > 0) {
      return new NumberPicker.decimal(
          initialValue: selectedDoubleValue,
          minValue: widget.minValue,
          maxValue: widget.maxValue,
          decimalPlaces: widget.decimalPlaces,
          highlightSelectedValue: widget.highlightSelectedValue,
          decoration: widget.decoration,
          onChanged: _handleValueChanged);
    } else {
      return new NumberPicker.integer(
        initialValue: selectedIntValue,
        minValue: widget.minValue,
        maxValue: widget.maxValue,
        step: widget.step,
        infiniteLoop: widget.infiniteLoop,
        zeroPad: widget.zeroPad,
        highlightSelectedValue: widget.highlightSelectedValue,
        decoration: widget.decoration,
        onChanged: _handleValueChanged,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: widget.title,
      titlePadding: widget.titlePadding,
      content: _buildNumberPicker(),
      actions: [
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: widget.cancelWidget,
        ),
        new FlatButton(
            onPressed: () => Navigator.of(context).pop(widget.decimalPlaces > 0
                ? selectedDoubleValue
                : selectedIntValue),
            child: widget.confirmWidget),
      ],
    );
  }
}
