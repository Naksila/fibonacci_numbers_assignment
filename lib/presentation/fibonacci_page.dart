import 'package:fibonacci_numbers_assignment/model/model.dart';
import 'package:fibonacci_numbers_assignment/utils/constant.dart';
import 'package:fibonacci_numbers_assignment/widget/crad_item.dart';
import 'package:flutter/material.dart';

class FibonacciPage extends StatefulWidget {
  const FibonacciPage({super.key});

  @override
  State<FibonacciPage> createState() => _FibonacciPageState();
}

class _FibonacciPageState extends State<FibonacciPage> {
  List<Map<String, dynamic>> fibonacci = [
    {
      'originalIndex': 0,
      'number': 0,
      'icon': Icons.circle,
    },
    {
      'originalIndex': 1,
      'number': 1,
      'icon': Icons.square_outlined,
    },
  ];

  List icons = [
    Icons.circle,
    Icons.square_outlined,
    Icons.close,
  ];

  List<FibonacciModel> listData = [];

  List<MapEntry<String, dynamic>> deletedItems = [];

  int? highlightKey;
  int? highlightKeyRestore;
  int fibonacciClose = 0;
  int fibonacciCircle = 0;
  int fibonacciSquareOutlined = 0;

  @override
  void initState() {
    generateFibonacci(fibonacciNumber);

    fibonacciCircle = fibonacci
        .where(
          (e) => e['icon'] == Icons.circle,
        )
        .toList()
        .length;

    fibonacciClose = fibonacci
        .where(
          (e) => e['icon'] == Icons.close,
        )
        .toList()
        .length;

    fibonacciSquareOutlined = fibonacci
        .where(
          (e) => e['icon'] == Icons.square_outlined,
        )
        .toList()
        .length;

    super.initState();
  }

  void generateFibonacci(int count) {
    for (int i = 2; i < count; i++) {
      int num = fibonacci[i - 1]['number'] + fibonacci[i - 2]['number'];
      IconData icon = icons[i % icons.length];
      fibonacci.add({
        'originalIndex': i,
        'number': num,
        'icon': icon,
      });
    }
  }

  void removeItem(int key, Map<String, dynamic> delectedItem) {
    setState(() {
      if (delectedItem.isNotEmpty) {
        deletedItems.add(MapEntry(key.toString(), delectedItem));
        fibonacci = fibonacci.where((e) => e['originalIndex'] != key).toList();
      }
    });
  }

  void restoreItem(int originalIndex) {
    if (deletedItems.isNotEmpty) {
      setState(() {
        MapEntry<String, dynamic> lastDeleted = deletedItems
            .firstWhere((e) => e.value['originalIndex'] == originalIndex);

        fibonacci.add(lastDeleted.value);
        fibonacci.sort(
          (a, b) => a['originalIndex'].compareTo(b['originalIndex']),
        );
        highlightKeyRestore = lastDeleted.value['originalIndex'];
      });
    }
  }

  void highlightItem(int key) {
    setState(() {
      highlightKey = key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fibonacci Numbers'),
      ),
      body: ListView.builder(
        itemCount: fibonacci.length,
        itemBuilder: (context, index) {
          return CradItem(
            onTap: () {
              listData.add(
                FibonacciModel(
                  originalIndex: fibonacci[index]['originalIndex'],
                  number: fibonacci[index]['number'],
                  icon: fibonacci[index]['icon'],
                ),
              );

              _showBottomSheet(
                listData,
                fibonacci[index]['originalIndex'],
                fibonacci[index]['icon'],
              );

              highlightItem(fibonacci[index]['originalIndex']);
              removeItem(
                fibonacci[index]['originalIndex'],
                fibonacci[index],
              );
            },
            highlightKey:
                fibonacci[index]['originalIndex'] == highlightKeyRestore
                    ? true
                    : false,
            colorHighlight: Colors.red[100],
            title:
                'Index: ${fibonacci[index]['originalIndex']}, Number: ${fibonacci[index]['number']}',
            icon: fibonacci[index]['icon'],
          );
        },
      ),
    );
  }

  Widget? _showBottomSheet(
    List<FibonacciModel> listData,
    int highlightKey,
    IconData icon,
  ) {
    listData.sort((a, b) => a.originalIndex.compareTo(b.originalIndex));
    final groupData = listData.where((e) => e.icon == icon).toList();

    showModalBottomSheet<void>(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(top: 16.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${groupData.length}/${icon == Icons.circle ? fibonacciCircle : icon == Icons.close ? fibonacciClose : fibonacciSquareOutlined}',
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: groupData.length,
                  itemBuilder: (context, index) {
                    return CradItem(
                      onTap: () {
                        listData.removeWhere((e) {
                          return e.originalIndex ==
                              groupData[index].originalIndex;
                        });

                        restoreItem(groupData[index].originalIndex);

                        Navigator.pop(context);
                      },
                      highlightKey:
                          highlightKey == groupData[index].originalIndex
                              ? true
                              : false,
                      colorHighlight: Colors.green[100],
                      title: 'Number ${groupData[index].number}',
                      subTitle: 'Index: ${groupData[index].originalIndex}',
                      icon: groupData[index].icon,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
