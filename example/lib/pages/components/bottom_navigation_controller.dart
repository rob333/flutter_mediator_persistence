import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({
    Key? key,
    required this.bottomNavItems,
    required this.pages,
    this.selectedColor,
    this.backgroundColor,
    this.selectedIndex = 0,
    this.onItemPressed,
    this.duration = const Duration(milliseconds: 500),
    this.transitionBuilder,
  }) : super(key: key);

  final List<BottomNavigationBarItem> bottomNavItems;
  final List<Widget> pages;
  final Color? selectedColor;
  final Color? backgroundColor;
  final int selectedIndex;
  final ValueChanged<int>? onItemPressed;
  final Duration duration;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

//* make icon and activeIcon different widget type
//* to make AnimatedSwitcher work
//* AnimatedSwitcher work on different widget type or provided by different Key:ValueKey
void makeBottomNavBarIconDifferentType(
    List<BottomNavigationBarItem> bottomNavItems,
    List<Widget> icons,
    List<Widget> activeIcons) {
  assert(activeIcons.isEmpty && icons.isEmpty,
      'activeIcons and icons should be empty');

  for (var i = 0; i < bottomNavItems.length; i++) {
    final item = bottomNavItems[i];
    var activeIcon = item.activeIcon;
    var icon = item.icon;
    final iconType = item.icon.runtimeType;

    // if activeIcon is not the same Icon with icon, otherwise, just as is
    if (activeIcon != icon) {
      if (iconType == activeIcon.runtimeType) {
        // assume if iconType is Icon, then it's widget tree is one depth below than the activeIcon widget tree
        final iconFlag = iconType == Icon;
        if (item.activeIcon is LimitedBox) {
          activeIcon = SizedBox(child: activeIcon);
          // try to make icon widget tree and activeIcon widget tree the same depth, Can reduce rebuild
          if (iconFlag) icon = LimitedBox(child: item.icon);
        } else {
          activeIcon = LimitedBox(child: activeIcon);
          // try to make icon widget tree and activeIcon widget tree the same depth, Can reduce rebuild
          if (iconFlag) icon = SizedBox(child: item.icon);
        }
      }
    }

    activeIcons.add(activeIcon);
    icons.add(icon);
  }
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  late int _currentBNBIndex;
  final defaultTransition = (Widget child, Animation<double> animation) =>
      ScaleTransition(child: child, scale: animation);
  final icons = <Widget>[];
  final activeIcons = <Widget>[];

  @override
  void initState() {
    _currentBNBIndex = widget.selectedIndex;
    makeBottomNavBarIconDifferentType(
        widget.bottomNavItems, icons, activeIcons);
    super.initState();
  }

  void _onBNavItemClick(int index) {
    setState(() {
      if (widget.onItemPressed != null) widget.onItemPressed!(index);
      _currentBNBIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.pages[_currentBNBIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: List.generate(widget.pages.length, (index) {
          final item = widget.bottomNavItems[index];
          return BottomNavigationBarItem(
            icon: AnimatedSwitcher(
              transitionBuilder: widget.transitionBuilder ?? defaultTransition,
              // child: index == _currentBNBIndex && activeIcons[index] != null ? activeIcons[index] : item.icon,
              // activeIcon ??= icon @BottomNavigationBarItem.constructor
              child:
                  index == _currentBNBIndex ? activeIcons[index] : icons[index],
              duration: widget.duration,
            ),
            label: item.label,
            backgroundColor: item.backgroundColor,
          );
        }),
        currentIndex: _currentBNBIndex,
        // fixedColor: Colors.amber[800],
        selectedItemColor: widget.selectedColor,
        backgroundColor: widget.backgroundColor,
        onTap: _onBNavItemClick,
      ),
    );
  }
}
