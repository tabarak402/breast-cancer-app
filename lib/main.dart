import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meme Kanseri Tahmin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE76F8A)),
        useMaterial3: true,
      ),
      home: const PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final List<String> featureNames = [
    'radius_mean', 'texture_mean', 'perimeter_mean', 'area_mean',
    'smoothness_mean', 'compactness_mean', 'concavity_mean',
    'concave points_mean', 'symmetry_mean', 'fractal_dimension_mean',
    'radius_se', 'texture_se', 'perimeter_se', 'area_se',
    'smoothness_se', 'compactness_se', 'concavity_se',
    'concave points_se', 'symmetry_se', 'fractal_dimension_se',
    'radius_worst', 'texture_worst', 'perimeter_worst', 'area_worst',
    'smoothness_worst', 'compactness_worst', 'concavity_worst',
    'concave points_worst', 'symmetry_worst', 'fractal_dimension_worst',
  ];

  final List<TextEditingController> controllers = List.generate(
    30, (_) => TextEditingController(),
  );

  String result = '';
  double probability = 0;
  bool isLoading = false;
  bool isMalignant = false;

  Future<void> predict() async {
    // Tüm alanlar dolu mu kontrol et
    for (int i = 0; i < 30; i++) {
      if (controllers[i].text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lütfen ${featureNames[i]} değerini girin!')),
        );
        return;
      }
    }

    setState(() => isLoading = true);

    try {
      final features = controllers
          .map((c) => double.parse(c.text.replaceAll(',', '.')))
          .toList();

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/predict'), // Emülatör için
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'features': features}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          result = data['tahmin'];
          probability = data['olasilik'] * 100;
          isMalignant = data['risk'] == 'YÜKSEK';
        });
      }
    } catch (e) {
      setState(() => result = 'Hata: API\'ye bağlanılamadı. $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void fillSampleData() {
    // Örnek Malignant hasta verisi
    final sample = [
      17.99, 10.38, 122.8, 1001.0, 0.1184, 0.2776, 0.3001, 0.1471, 0.2419,
      0.07871, 1.095, 0.9053, 8.589, 153.4, 0.006399, 0.04904, 0.05373,
      0.01587, 0.03003, 0.006193, 25.38, 17.33, 184.6, 2019.0, 0.1622,
      0.6656, 0.7119, 0.2654, 0.4601, 0.1189
    ];
    for (int i = 0; i < 30; i++) {
      controllers[i].text = sample[i].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F8A),
        title: const Text(
          '🔬 Meme Kanseri Tahmin',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bilgi kartı
            Card(
              color: const Color(0xFFFFE0E6),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  '⚕️ Bu uygulama hücre çekirdeği ölçümlerini analiz ederek '
                  'tümörün iyi huylu mu kötü huylu mu olduğunu tahmin eder. '
                  'Klinik değerlendirmenin yerini tutmaz.',
                  style: TextStyle(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Örnek veri butonu
            OutlinedButton.icon(
              onPressed: fillSampleData,
              icon: const Icon(Icons.science),
              label: const Text('Örnek Hasta Verisi Doldur'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE76F8A),
              ),
            ),
            const SizedBox(height: 16),

            // Özellik giriş alanları
            ...List.generate(30, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: controllers[i],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: featureNames[i],
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                ),
              ),
            )),

            const SizedBox(height: 16),

            // Tahmin butonu
            ElevatedButton(
              onPressed: isLoading ? null : predict,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE76F8A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'TAHMİN ET',
                      style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),

            const SizedBox(height: 20),

            // Sonuç kartı
            if (result.isNotEmpty)
              Card(
                color: isMalignant
                    ? const Color(0xFFFFEBEE)
                    : const Color(0xFFE8F5E9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isMalignant ? Colors.red : Colors.green,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        isMalignant ? '⚠️ YÜKSEK RİSK' : '✅ DÜŞÜK RİSK',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isMalignant ? Colors.red : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: probability / 100,
                        backgroundColor: Colors.grey[200],
                        color: isMalignant ? Colors.red : Colors.green,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Olasılık: %${probability.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '⚕️ Bu sonuç yalnızca bilgi amaçlıdır.\nLütfen bir doktora danışın.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}