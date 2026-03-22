import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'لعبة جدول الضرب',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة القلب
            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(height: 30),

            // الاسم
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.3),
                    spreadRadius: 5,
                    blurRadius: 15,
                  ),
                ],
              ),
              child: const Text(
                'غنى',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // عنوان اللعبة
            const Text(
              'لعبة جدول الضرب',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 50),

            // زر البدء
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MultiplicationGame(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
              ),
              child: const Text(
                'ابدأ اللعب',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiplicationGame extends StatefulWidget {
  const MultiplicationGame({super.key});

  @override
  State<MultiplicationGame> createState() => _MultiplicationGameState();
}

class _MultiplicationGameState extends State<MultiplicationGame> {
  final Random _random = Random();
  final TextEditingController _answerController = TextEditingController();

  int _num1 = 0;
  int _num2 = 0;
  int _score = 0;
  int _hearts = 3;
  bool _gameOver = false;
  bool _isWinner = false;
  String _message = '';
  Color _messageColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    setState(() {
      _num1 = _random.nextInt(10) + 1;
      _num2 = _random.nextInt(10) + 1;
      _answerController.clear();
      _message = '';
    });
  }

  void _checkAnswer() {
    if (_gameOver) return;

    // تجاهل الإدخال الفارغ
    if (_answerController.text.trim().isEmpty) {
      return;
    }

    final userAnswer = int.tryParse(_answerController.text);
    final correctAnswer = _num1 * _num2;

    setState(() {
      if (userAnswer == correctAnswer) {
        _score++;

        // التحقق من الفوز عند الوصول لـ 10 نقاط
        if (_score >= 10) {
          _isWinner = true;
          _message = 'مبروك! لقد فزت! 🎉';
          _messageColor = Colors.green;
        } else {
          _message = 'رائع! إجابة صحيحة! 🎉';
          _messageColor = Colors.green;
          Future.delayed(const Duration(milliseconds: 800), () {
            _generateNewQuestion();
          });
        }
      } else {
        _hearts--;
        _message = 'الإجابة الصحيحة: $correctAnswer';
        _messageColor = Colors.red;

        if (_hearts <= 0) {
          _gameOver = true;
          _message = 'انتهت اللعبة! نقاطك: $_score';
        } else {
          Future.delayed(const Duration(milliseconds: 1500), () {
            _generateNewQuestion();
          });
        }
      }
    });
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _hearts = 3;
      _gameOver = false;
      _isWinner = false;
      _message = '';
      _generateNewQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    // عرض شاشة الفوز
    if (_isWinner) {
      return Scaffold(
        backgroundColor: Colors.green[50],
        body: Stack(
          children: [
            // الخلفية مع الألعاب النارية
            ...List.generate(20, (index) {
              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(milliseconds: 1000 + (index * 100)),
                builder: (context, double value, child) {
                  return Positioned(
                    left: 50.0 + (index * 15) + (value * 100),
                    top: 50.0 + (index * 30) - (value * 200),
                    child: Opacity(
                      opacity: 1 - value,
                      child: Icon(
                        index % 2 == 0 ? Icons.star : Icons.auto_awesome,
                        color: index % 3 == 0 ? Colors.yellow : (index % 3 == 1 ? Colors.orange : Colors.pink),
                        size: 30 + (value * 20),
                      ),
                    ),
                  );
                },
              );
            }),

            // القلوب المتحركة
            ...List.generate(15, (index) {
              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(milliseconds: 800 + (index * 150)),
                builder: (context, double value, child) {
                  return Positioned(
                    left: 30.0 + (index * 25),
                    top: MediaQuery.of(context).size.height - (value * MediaQuery.of(context).size.height),
                    child: Opacity(
                      opacity: 1 - (value * 0.5),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red.withValues(alpha: 0.8),
                        size: 20 + (value * 15),
                      ),
                    ),
                  );
                },
              );
            }),

            // المحتوى الرئيسي
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // أيقونة الكأس
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 120,
                  ),
                  const SizedBox(height: 30),

                  // رسالة الفوز
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.3),
                          spreadRadius: 5,
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'مبروك غنى!',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'لقد فزت! 🎉',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // عرض النقاط
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'حصلت على $_score نقاط!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // زر العب مرة أخرى
                  ElevatedButton(
                    onPressed: _restartGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                    ),
                    child: const Text(
                      'العب مرة أخرى',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'لعبة جدول الضرب',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Column(
            children: [
              // الصف العلوي: النقاط يسار، القلوب يمين
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // النقاط في اليسار
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'النقاط: $_score',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // القلوب في اليمين
                  Row(
                    children: List.generate(3, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Icon(
                          index < _hearts ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // السؤال
              if (!_gameOver) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    '$_num1 × $_num2 = ؟',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // حقل عرض الإجابة مع رسالة الخطأ داخله
                Container(
                  width: 180,
                  height: 100,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _messageColor == Colors.red && _message.isNotEmpty
                        ? Colors.red.withValues(alpha: 0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _messageColor == Colors.red && _message.isNotEmpty
                          ? Colors.red
                          : Colors.green,
                      width: 3,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // الرقم المدخل أو علامة الاستفهام
                      Text(
                        _answerController.text.isEmpty ? '؟' : _answerController.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _messageColor == Colors.red && _message.isNotEmpty
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      // رسالة الإجابة الخاطئة داخل المربع
                      if (_message.isNotEmpty && _messageColor == Colors.red) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _message,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // لوحة الأرقام
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // الصف الأول: 1, 2, 3
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildNumberButton('1'),
                          const SizedBox(width: 8),
                          _buildNumberButton('2'),
                          const SizedBox(width: 8),
                          _buildNumberButton('3'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // الصف الثاني: 4, 5, 6
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildNumberButton('4'),
                          const SizedBox(width: 8),
                          _buildNumberButton('5'),
                          const SizedBox(width: 8),
                          _buildNumberButton('6'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // الصف الثالث: 7, 8, 9
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildNumberButton('7'),
                          const SizedBox(width: 8),
                          _buildNumberButton('8'),
                          const SizedBox(width: 8),
                          _buildNumberButton('9'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // الصف الرابع: مسح, 0, تحقق
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton('مسح', Colors.orange, () {
                            setState(() {
                              _answerController.clear();
                            });
                          }),
                          const SizedBox(width: 8),
                          _buildNumberButton('0'),
                          const SizedBox(width: 8),
                          _buildActionButton('✓', Colors.green, _checkAnswer),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              // رسالة النجاح
              if (_message.isNotEmpty && _messageColor == Colors.green) ...[
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: Text(
                    _message,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              // رسالة نهاية اللعبة
              if (_gameOver) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: Text(
                    _message,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _restartGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'العب مرة أخرى',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // بناء زر رقم
  Widget _buildNumberButton(String number) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _answerController.text += number;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // بناء زر إجراء (مسح، تحقق)
  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}

//////sdg/s/fg/w   
///
/// mohammad
/// 
/// issa