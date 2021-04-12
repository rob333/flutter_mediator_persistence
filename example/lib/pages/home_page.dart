import 'package:flutter/material.dart';
import 'package:flutter_mediator_persistence/mediator.dart';

//* Step1: import the var.dart
import '/var.dart';
import 'components/widget_extension.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Int Demo')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You have pushed the button this many times:'),
          //* Step3: Create a consume widget with
          //* `globalConsume` or `watchedVar.consume` to register the
          //* watched variable to the host to rebuild it when updating.
          globalConsume(
            () => Text(
              '${touchCount.value}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ],
      ).center(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            //* Stet4A: Make an update to the watched variable.
            onPressed: () => touchCount.value++,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
            heroTag: null,
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            //* Stet4B: Make an update to the watched variable.
            onPressed: () => touchCount.value--,
            tooltip: 'decrement',
            child: const Icon(
              Icons.remove,
              color: Colors.deepOrange,
            ),
            heroTag: null,
          ),
          FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () => onSignOut(context),
            tooltip: 'login.signOut'.i18n(context),
            child: Image.asset('assets/images/signout.png'),
            heroTag: null,
          ),
        ],
      ),
    );
  }
}
