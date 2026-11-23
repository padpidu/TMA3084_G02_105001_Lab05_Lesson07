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

  void _sort<T extends Comparable>(
      T Function(Car car) getField, int columnIndex, bool ascending) {
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
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            columns: [
              DataColumn(
                label: const Text('Car Make'),
                onSort: (i, asc) => _sort<String>((c) => c.make, i, asc),
              ),
              DataColumn(
                label: const Text('Model'),
                onSort: (i, asc) => _sort<String>((c) => c.model, i, asc),
              ),
              DataColumn(
                label: const Text('Price (RM)'),
                numeric: true,
                onSort: (i, asc) => _sort<num>((c) => c.price, i, asc),
              ),
            ],
            rows: _cars
                .map((car) => DataRow(cells: [
                      DataCell(Text(car.make)),
                      DataCell(Text(car.model)),
                      DataCell(Text(car.price.toStringAsFixed(0))),
                    ]))
                .toList(),
          ),
        ),
      ),
    );
  }
}