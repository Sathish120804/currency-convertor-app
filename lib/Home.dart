import 'package:currency_converter_app/fetchrate.dart';
import 'package:flutter/material.dart';
// fetchRate() function
import 'ratesmodel.dart'; // RatesModel

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late Future<RatesModel> futureRates;
  String fromCurrency = 'USD';
  String toCurrency = 'GBP';
  String resultText = '';

  @override
  void initState() {
    super.initState();
    futureRates = fetchRate();
  }

  void convert(RatesModel model) {
    final input = double.tryParse(_controller.text);
    if (input == null) {
      setState(() {
        resultText = 'Enter a valid number';
      });
      return;
    }

    final fromRate = model.rates[fromCurrency];
    final toRate = model.rates[toCurrency];

    if (fromRate == null || toRate == null) {
      setState(() {
        resultText = 'Invalid currency selected';
      });
      return;
    }

    final usdAmount = input / fromRate;
    final convertedAmount = usdAmount * toRate;

    setState(() {
      resultText =
          '$input $fromCurrency = ${convertedAmount.toStringAsFixed(2)} $toCurrency';
    });
  }

  void clear() {
    _controller.clear();
    setState(() {
      resultText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        centerTitle: true,
      ),
      body: FutureBuilder<RatesModel>(
        future: futureRates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Failed to load rates.'));
          }

          final rates = snapshot.data!;
          final currencyList = rates.rates.keys.toList()..sort();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Value to Convert:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter amount',
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: fromCurrency,
                      decoration: const InputDecoration(labelText: 'From'),
                      items: currencyList
                          .map((code) => DropdownMenuItem(value: code, child: Text(code)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => fromCurrency = value);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: toCurrency,
                      decoration: const InputDecoration(labelText: 'To'),
                      items: currencyList
                          .map((code) => DropdownMenuItem(value: code, child: Text(code)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => toCurrency = value);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: clear, child: const Text('Clear')),
                        ElevatedButton(
                          onPressed: () => convert(rates),
                          child: const Text('Calculate'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      resultText,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
