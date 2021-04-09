# Flutter Mediator Persistence

<table cellpadding="0" border="0">
  <tr>
    <td align="right">
    <a href="https://github.com/rob333/flutter_mediator">Flutter Mediator</a>
    </td>
    <td>
    <a href="https://pub.dev/packages/flutter_mediator"><img src="https://img.shields.io/pub/v/flutter_mediator.svg" alt="pub.dev"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator/blob/main/LICENSE"><img src="https://img.shields.io/github/license/rob333/flutter_mediator.svg" alt="License"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator/actions"><img src="https://github.com/rob333/flutter_mediator/workflows/Build/badge.svg" alt="Build Status"></a>
    </td>
    <td>
    Global Mode + Model Mode
    </td>
  </tr>
  <tr>
    <td align="right">
    <a href="https://github.com/rob333/flutter_mediator_lite">Lite</a>
    </td>
    <td>
    <a href="https://pub.dev/packages/flutter_mediator_lite"><img src="https://img.shields.io/pub/v/flutter_mediator_lite.svg" alt="pub.dev"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator_lite/blob/main/LICENSE"><img src="https://img.shields.io/github/license/rob333/flutter_mediator_lite.svg" alt="License"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator_lite/actions"><img src="https://github.com/rob333/flutter_mediator_lite/workflows/Build/badge.svg" alt="Build Status"></a>
    </td>
    <td>
    Global Mode only
    </td>
  </tr>
  <tr>
    <td align="right">
    <a href="https://github.com/rob333/flutter_mediator_persistence">Persistence</a>
    </td>
    <td>
    <a href="https://pub.dev/packages/flutter_mediator_persistence"><img src="https://img.shields.io/pub/v/flutter_mediator_persistence.svg" alt="pub.dev"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator_persistence/blob/main/LICENSE"><img src="https://img.shields.io/github/license/rob333/flutter_mediator_persistence.svg" alt="License"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator_persistence/actions"><img src="https://github.com/rob333/flutter_mediator_persistence/workflows/Build/badge.svg" alt="Build Status"></a>
    </td>
    <td>
    Lite + Persistence
    </td>
  </tr>
  <tr>
    <td align="right">
    Example
    </td>
    <td colspan="4">
    <a href="https://github.com/rob333/Flutter-logins-to-a-REST-server-with-i18n-theming-persistence-and-state-management">Logins to a REST server with i18n, theming, persistence and state management.</a>
    </td>
  </tr>
</table>

<br>

Flutter Mediator Persistence is a super easy state management package with built in persistence capability, base on the [Flutter Mediator Lite][lite].

<!--
<table border="0" align="center">
  <tr>
    <td>
      <img src="https://raw.githubusercontent.com/rob333/flutter_mediator_persistence/main/doc/images/persistence.gif">
    </td>
  </tr>
</table>

<br>
-->

<br>
<hr>

## Table of Contents

- [Setting up](#setting-up)
- [Steps](#steps)
  - [Case 1: Int](#case-1-int)
  - [Case 2: List](#case-2-list)
  - [Case 3: Locale setting with Built in Persistence](#case-3-locale-setting-with-built-in-persistence)
  - [Case 4: Scrolling effect](#case-4-scrolling-effect)
- [Recap](#recap)
- [Global Get](#global-get)
  - [Case 1: By `Type`](#case-1-by-type)
  - [Case 2: By `tag`](#case-2-by-tag)
- [Global Broadcast](#global-broadcast)
- [Persistence](#persistence)
  - [`defaultVal.globalPersist('key')`](#defaultvalglobalpersistkey)
  - [`await initGlobalPersis()`](#await-initglobalpersis)
  - [`getPersistStore()`](#getpersiststore)
  - [`persistVar.remove()`](#persistvarremove)
  - [`persistVar.store(input)`](#persistvarstoreinput)
- [Versions](#versions)
- [Example: Logins to a REST server](#example-logins-to-a-rest-server)
- [Flutter Widget of the Week: InheritedModel explained](#flutter-widget-of-the-week-inheritedmodel-explained)
- [Changelog](#changelog)
- [License](#license)

<hr>

## Setting up

Add the following dependency to pubspec.yaml of your flutter project:

```yaml
dependencies:
  flutter_mediator_persistence: "^1.0.0"
```

Import flutter_mediator_persistence in files that will be used:

```dart
import 'package:flutter_mediator_persistence/mediator.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.dev/docs).

&emsp; [Table of Contents]

## Steps

1. Declare the watched variable with `globalWatch`.<br>
   Declare the persistent wathced variable with `defaultVal.globalPersist('key')`<br>
   **Suggest to put the watched variables into a file [var.dart][example/lib/var.dart] and then import it.**

2. Initial the persistent store with `await initGlobalPersist();` and create the host with `globalHost(child: MyApp())` at the top of the widget tree.

3. Create a widget with `globalConsume` or `watchedVar.consume` to register the watched variable to the host to rebuild it when updating.

4. Make an update to the watched variable, by `watchedVar.value` or `watchedVar.ob.updateMethod(...)`.

&emsp; [Table of Contents]

### Case 1: Int

Step 1: [var.dart][example/lib/var.dart]

```dart
const DefaultLocale = 'en';
//* Declare the persistent watched variable with `defaultVal.globalPersist('key')`
///    int: 0.globalPersist('intKey');
/// double: 0.0.globalPersist('doubleKey');
/// String: ''.globalPersist('StringKey');
///   bool: false.globalPersist('boolKey');
final locale = DefaultLocale.globalPersist('locale');
final themeIdx = 1.globalPersist('themeIdx');

//* Declare the watched variable with `globalWatch(initialValue)`.
final touchCount = globalWatch(0);
```

Step 2: [main.dart][example/lib/main.dart]

```dart
Future<void> main() async {
  //* Step2: Initial the persistent store.
  await initGlobalPersist();

  runApp(
    //* Step2: Create the host with `globalHost`
    //* at the top of the widget tree.
    globalHost(
      child: MyApp(),
    ),
  );
}
```

Step 3: [example/lib/pages/home_page.dart][]

```dart
Scaffold(
  appBar: AppBar(title: const Text('Int Demo')),
  body: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('You have pushed the button this many times:'),
      //* Step3: Create a widget with `globalConsume` or `watchedVar.consume`
      //* to register the watched variable to the host to rebuild it when updating.
      globalConsume(
        () => Text(
          '${touchCount.value}',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
   // ...
```

Step 4: [example/lib/pages/home_page.dart][]

```dart
FloatingActionButton(
  //* Stet4: Make an update to the watched variable.
  onPressed: () => touchCount.value++,
  tooltip: 'Increment',
  child: const Icon(Icons.add),
  heroTag: null,
),
```

&emsp; [Table of Contents]

### Case 2: List

[example/lib/pages/list_page.dart][]

Step 1: [var.dart][example/lib/var.dart]

```dart
//* Step1: Declare the watched variable with `globalWatch` in the var.dart.
//* And then import it in the file.
final data = globalWatch(<ListItem>[]);
```

Step 3:

```dart
return Scaffold(
  appBar: AppBar(title: const Text('List Demo')),
  //* Step3: Create a widget with `globalConsume` or `watchedVar.consume`
  //* to register the watched variable to the host to rebuild it when updating.
  body: globalConsume(
    () => GridView.builder(
      itemCount: data.value.length,

    // ...
```

Step 4:

```dart
void updateListItem() {
  // ...

  //* Step4: Make an update to the watched variable.
  //* watchedVar.ob = watchedVar.notify() and then return the underlying object
  data.ob.add(ListItem(itemName, units, color));
}
```

&emsp; [Table of Contents]

### Case 3: Locale setting with Built in Persistence

Step 1: [var.dart][example/lib/var.dart]

```dart
const DefaultLocale = 'en';
//* Declare the persistent watched variable with `defaultVal.globalPersist('key')`
///    int: 0.globalPersist('intKey');
/// double: 0.0.globalPersist('doubleKey');
/// String: ''.globalPersist('StringKey');
///   bool: false.globalPersist('boolKey');
final locale = DefaultLocale.globalPersist('locale');
final themeIdx = 1.globalPersist('themeIdx');
```

Step 2-1: [main.dart][example/lib/main.dart]

```dart
Future<void> main() async {
  //* Initial the persistent store.
  await initGlobalPersist();

  runApp(
    //* Step2: Create the host with `globalHost` at the top of the widget tree.
    globalHost(child: MyApp())
  );
}
```

Step 2-2: [main.dart][example/lib/main.dart]

```dart
//* Initialize the locale with the persistent value.
localizationsDelegates: [
  FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
      forcedLocale: Locale(locale.value),
      fallbackFile: DefaultLocale,
      // ...
    ),
    // ...
  ),
],
```

Step 3: [example/lib/pages/locale_page.dart][]

```dart
return SizedBox(
  child: Row(
    children: [
      //* Step3: Create a widget with `globalConsume` or `watchedVar.consume`
      //* to register the watched variable to the host to rebuild it when updating.
      //* `watchedVar.consume()` is a helper function to
      //* `touch()` itself first and then `globalConsume`.
      locale.consume(() => Text('${'app.hello'.i18n(context)} ')),
      Text('$name, '),

      // ...
    ],
  ),
);
```

Step 4: [var.dart][example/lib/var.dart]

```dart
Future<void> changeLocale(BuildContext context, String countryCode) async {
  final loc = Locale(countryCode);
  await FlutterI18n.refresh(context, loc);
  //* Step4: Make an update to the watched variable.
  //* The persistent watched variable will update the persistent value automatically.
  locale.value = countryCode;
}
```

&emsp; [Table of Contents]

### Case 4: Scrolling effect

[example/lib/pages/scroll_page.dart][]

Step 1:

```dart
//* Declare the persistent watched variable with `defaultVal.globalPersist('key')`
final scrollOffset = 0.0.globalPersist('ScrollOffsetDemo');
```

Step 3:

```dart
class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //* Step3: Create a widget with `globalConsume` or `watchedVar.consume`
    //* to register the watched variable to the host to rebuild it when updating.
    return globalConsume(
      () => Container(
        color: Colors.black
            .withOpacity((scrollOffset.value / 350).clamp(0, 1).toDouble()),
        // ...
      ),
    );
  }
}
```

Step 4:

```dart
class _ScrollPageState extends State<ScrollPage> {
  //* Step4: Initialize the scroll offset with the persistent value.
  final _scrollController =
      ScrollController(initialScrollOffset: scrollOffset.value);

  @override
  void initState() {
    _scrollController.addListener(() {
      //* Step4: Make an update to the watched variable.
      scrollOffset.value = _scrollController.offset;
    });
    super.initState();
  }
```

&emsp; [Table of Contents]

## Recap

- At step 1, `globalWatch(variable)` creates a watched variable from the variable. <br>
  Declare the persistent watched variable with `defaultVal.globalPersist('key')`

```dart
///    int: 0.globalPersist('intKey');
/// double: 0.0.globalPersist('doubleKey');
/// String: ''.globalPersist('StringKey');
///   bool: false.globalPersist('boolKey');
```

- At step 3, create a widget and register it to the host to rebuild it when updating,
  <br> use `globalConsume(() => widget)` if the value of the watched variable is used inside the widget;
  <br>or use `watchedVar.consume(() => widget)` to `touch()` the watched variable itself first and then `globalConsume(() => widget)`.

- At step 4, update to the `watchedVar.value` will notify the host to rebuild; or the underlying object would be a class, then use `watchedVar.ob.updateMethod(...)` to notify the host to rebuild. <br>**`watchedVar.ob = watchedVar.notify() and then return the underlying object`.**

&emsp; [Table of Contents]

## Global Get

`globalGet<T>({Object? tag})` to retrieve the watched variable from another file.

- With `globalWatch(variable)`, the watched variable will be retrieved by the `Type` of the variable, i.e. retrieve by `globalGet<Type>()`.

- With `globalWatch(variable, tag: object)`, the watched variable will be retrieved by the tag, i.e. retrieve by `globalGet(tag: object)`.

&emsp; [Table of Contents]

### Case 1: By `Type`

```dart
//* Step1: Declare the watched variable with `globalWatch`.
final touchCount = globalWatch(0);
```

`lib/pages/locale_page.dart`
[example/lib/pages/locale_page.dart][]

```dart
class LocalePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //* Get the watched variable by it's [Type] from `../main.dart`
    final mainInt = globalGet<int>();

    return Container(
      // ...
          const SizedBox(height: 25),
          //* `globalConsume` the watched variable from `../main.dart`
          globalConsume(
            () => Text(
              'You have pressed the button at the first page ${mainInt.value} times',
            ),
      // ...
```

&emsp; [Table of Contents]

### Case 2: By `tag`

```dart
//* Step1: Declare the watched variable with `globalWatch`.
final touchCount = globalWatch(0, tag: 'tagCount');
```

`lib/pages/locale_page.dart`
[example/lib/pages/locale_page.dart][]

```dart
class LocalePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //* Get the watched variable by [tag] from `../main.dart`
    final mainInt = globalGet('tagCount');

    return Container(
      // ...
          const SizedBox(height: 25),
          //* `globalConsume` the watched variable from `../main.dart`
          globalConsume(
            () => Text(
              'You have pressed the button at the first page ${mainInt.value} times',
            ),
      // ...
```

<br>

### **Note**

- **Make sure the watched variable is initialized, only after the page is loaded.**

- **When using `Type` to retrieve the watched variable, only the first one of the `Type` is returned.**

> Or put the watched variables into a file and then import it.

&emsp; [Table of Contents]

## Global Broadcast

- `globalBroadcast()`, to broadcast to all the globalConsume widgets.
- `globalConsumeAll(Widget Function() create, {Key? key})`, to create a widget which will be rebuilt whenever any watched variables changes are made.
- `globalFrameAspects`, a getter, to return the updated aspects.
- `globalAllAspects`, a getter, to return all the aspects that has been registered.

&emsp; [Table of Contents]

## Persistence

### `defaultVal.globalPersist('key')`

Create a persistent watched variable. Type of `int`, `double`, `String`, and `bool` are supported.

```dart
///    int: 0.globalPersist('intKey');
/// double: 0.0.globalPersist('doubleKey');
/// String: ''.globalPersist('StringKey');
///   bool: false.globalPersist('boolKey');
/// ex:
const DefaultLocale = 'en';
final locale = DefaultLocale.globalPersist('locale');
final themeIdx = 1.globalPersist('themeIdx');
```

### `await initGlobalPersis()`

Initial the persistent store in the `main()` before `runApp()`.

```dart
Future<void> main() async {
  //* Initial the persistent store.
  await initGlobalPersist();

  runApp(
    //* Create the host with `globalHost` at the top of the widget tree.
    globalHost(child: MyApp())
  );
}
```

### `getPersistStore()`

Get the backend persistent store, a `SharedPreferences`.

```dart
final prefs = getPersistStore();`
```

### `persistVar.remove()`

Remove the persistent key/value from the persistent store, and set the value of the persistVar to the default value.<br>
**Won't notify the host to rebuild.**

### `persistVar.store(input)`

Store the `input` value to the persistVar.

**Won't notify the host to rebuild.**

&emsp; [Table of Contents]

## Versions

- [Flutter Mediator][flutter_mediator]: Global Mode + Model Mode.
- [Lite][]: Global Mode only.
- [Persistence][]: Lite + built in persistence.

&emsp; [Table of Contents]

## Example: Logins to a REST server

A boilerplate example that logins to a REST server with i18n, theming, persistence and state management.

Please see the [login to a REST server example][loginrestexample] for details.

&emsp; [Table of Contents]

<br>

[table of contents]: #table-of-contents
[flutter_mediator]: https://github.com/rob333/flutter_mediator/
[lite]: https://github.com/rob333/flutter_mediator_lite/
[persistence]: https://github.com/rob333/flutter_mediator_persistence/
[inheritedmodel]: https://api.flutter.dev/flutter/widgets/InheritedModel-class.html
[example/lib/main.dart]: https://github.com/rob333/flutter_mediator_persistence/blob/main/example/lib/main.dart
[example/lib/var.dart]: https://github.com/rob333/flutter_mediator_persistence/blob/main/example/lib/var.dart
[example/lib/pages/home_page.dart]: https://github.com/rob333/flutter_mediator_persistence/blob/main/example/lib/pages/home_page.dart
[example/lib/pages/list_page.dart]: https://github.com/rob333/flutter_mediator_persistence/blob/main/example/lib/pages/list_page.dart
[example/lib/pages/locale_page.dart]: https://github.com/rob333/flutter_mediator_persistence/blob/main/example/lib/pages/locale_page.dart
[example/lib/pages/scroll_page.dart]: https://github.com/rob333/flutter_mediator_persistence/blob/main/example/lib/pages/scroll_page.dart
[loginrestexample]: https://github.com/rob333/Flutter-logins-to-a-REST-server-with-i18n-theming-persistence-and-state-management

## Flutter Widget of the Week: InheritedModel explained

InheritedModel provides an aspect parameter to its descendants to indicate which fields they care about to determine whether that widget needs to rebuild. InheritedModel can help you rebuild its descendants only when necessary.

<p align="center">
<a href="https://www.youtube.com/watch?feature=player_embedded&v=ml5uefGgkaA
" target="_blank"><img src="https://img.youtube.com/vi/ml5uefGgkaA/0.jpg" 
alt="Flutter Widget of the Week: InheritedModel Explained" /></a></p>

## Changelog

Please see the [Changelog](https://github.com/rob333/flutter_mediator_persistence/blob/main/CHANGELOG.md) page.

<br>

## License

Flutter Mediator Persistence is distributed under the MIT License. See [LICENSE](https://github.com/rob333/flutter_mediator_persistence/blob/main/LICENSE) for more information.

&emsp; [Table of Contents]
