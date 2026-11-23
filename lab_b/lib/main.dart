import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class Car {
  final String make;
  final String model;
  final double price;
  const Car(this.make, this.model, this.price);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab B',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const CarTablePage(),
    );
  }
}

class CarTablePage extends StatefulWidget {
  const CarTablePage({super.key});

  @override
  State<CarTablePage> createState() => _CarTablePageState();
}

class _CarTablePageState extends State<CarTablePage> {
  final List<Car> _cars = [
    const Car('Toyota', 'Vios', 89000),
    const Car('Honda', 'City', 82000),
    const Car('Proton', 'X50', 93000),
    const Car('Perodua', 'Myvi', 51000),
    const Car('Mazda', 'CX-5', 143000),
  ];

  int? _sortColumnIndex;
  bool _sortAscending = true;
  String _searchText = '';

  List<Car> get _filteredCars {
    final query = _searchText.trim().toLowerCase();
    if (query.isEmpty) return _cars;
    return _cars
        .where((car) => car.make.toLowerCase().contains(query))
        .toList();
  }

  void _sort<T extends Comparable>(
    T Function(Car car) getField,
    int columnIndex,
    bool ascending,
  ) {
    _cars.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by Car Make',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchText = value),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columns: [
                    DataColumn(
                      label: const Text('Car Make'),
                      onSort: (columnIndex, ascending) => _sort<String>(
                        (car) => car.make,
                        columnIndex,
                        ascending,
                      ),
                    ),
                    DataColumn(
                      label: const Text('Model'),
                      onSort: (columnIndex, ascending) => _sort<String>(
                        (car) => car.model,
                        columnIndex,
                        ascending,
                      ),
                    ),
                    DataColumn(
                      label: const Text('Price (RM)'),
                      numeric: true,
                      onSort: (columnIndex, ascending) => _sort<num>(
                        (car) => car.price,
                        columnIndex,
                        ascending,
                      ),
                    ),
                  ],
                  rows: _filteredCars
                      .map(
                        (car) => DataRow(
                          cells: [
                            DataCell(Text(car.make)),
                            DataCell(Text(car.model)),
                            DataCell(Text(car.price.toStringAsFixed(0))),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
