import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mediator_persistence/mediator.dart';

final scrollOffset = 0.0.globalPersist('ScrollOffsetDemo');

class ScrollPage extends StatefulWidget {
  const ScrollPage({Key? key}) : super(key: key);

  @override
  _ScrollPageState createState() => _ScrollPageState();
}

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 150),
        child: CustomAppBar(
          header: SafeArea(
            child: Text(
              'ScrollOffset Demo',
              style: TextStyle(
                color: Colors.lightBlue.shade400,
                backgroundColor: Colors.transparent,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        key: const PageStorageKey('ScrollView'),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.orangeAccent,
                image: DecorationImage(
                  image: AssetImage('assets/images/trees.png'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
              alignment: Alignment.center,
              height: 250,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  leading: Icon(
                    Icons.people_outline_rounded,
                    color: Colors.blue.shade400,
                  ),
                  title: Text(
                    data[index].name,
                    style: TextStyle(color: Colors.blue.shade400),
                  ),
                  subtitle: Text(
                    'Price: ${data[index].price}',
                    style: TextStyle(color: Colors.blue.shade400),
                  ),
                );
              },
              childCount: data.length,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({required this.header, Key? key}) : super(key: key);
  final Widget header;

  @override
  Widget build(BuildContext context) {
    //* Step3: Create a consume widget with
    //* `globalConsume` or `watchedVar.consume` to register the
    //* watched variable to the host to rebuild it when updating.
    return globalConsume(
      () => Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 24.0,
        ),
        color: Colors.black
            .withOpacity((scrollOffset.value / 350).clamp(0, 1).toDouble()),
        child: header,
      ),
    );
  }
}

class Product {
  const Product({required this.name, required this.price});

  final String name;
  final int price;
}

final data = List<Product>.generate(100, (i) {
  return Product(
    name: 'Description $i',
    price: Random().nextInt(100) + 1,
  );
});
