import 'package:flutter/material.dart';

double liters = 0;
double price = 5.00;
double result = 0;
List<double> payments = [];

void main() {
  runApp(const MaterialApp(
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo1.png', width: 100, height: 100),
            const SizedBox(height: 20),
            const Text('Bem-vindo ao Posto de Gasolina'),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Inicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CalculatorScreen()));
              },
              child: const Text('Central de cobrança de combustivel'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PaymentListScreen()));
              },
              child: const Text('Central de pagamentos'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentListScreen extends StatelessWidget {
  const PaymentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de pagamentos"),
      ),
      body: ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                'Pagamento $index: R\$ ${payments[index].toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Central de cobrança de combustivel: Calculadora de Combustível'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Litros de combustível consumidas'),
              onChanged: (value) {
                setState(() {
                  liters = double.tryParse(value) ?? 0;
                });
              },
            ),
            Text('\n Preço por litro aplicado: R\$ $price'),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PaymentConfirmationScreen()));
              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentConfirmationScreen extends StatelessWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmação de Pagamento'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Total a pagar: R\$ ${liters * price} Por favor, confirme o pagamento.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double totalPayment = liters * price;
                payments.add(totalPayment);
                Navigator.of(context).pop();
              },
              child: const Text('Pagar'),
            ),
          ],
        ),
      ),
    );
  }
}
