import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  late SharedPreferences _prefs;
  late DateTime _lastQuoteChangeDate;
  late int _currentQuoteIndex = 0;

  final List<String> dailyQuotes = [
    '"The only way to do great work is to love what you do." \n- Steve Jobs',
    "In three words I can sum up everything I've learned about life: it goes on. \n- Robert Frost'",
    'The only limit to our realization of tomorrow will be our doubts of today. \n- Franklin D. Roosevelt',
    "Success is not final, failure is not fatal: It is the courage to continue that counts. \n- Winston Churchill"
    "The only thing necessary for the triumph of evil is for good men to do nothing. \n- Edmund Burke"
     "The greatest glory in living lies not in never falling, but in rising every time we fall." "\n- Nelson Mandela"
   "To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment." "\n- Ralph Waldo Emerson"
  "In the end, we will remember not the words of our enemies, but the silence of our friends." "\n- Martin Luther King Jr."

    // Add more quotes here
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    _lastQuoteChangeDate =
        _prefs.get('lastQuoteChangeDate') as DateTime? ?? DateTime.now().subtract(const Duration(days: 1));
    _currentQuoteIndex = _prefs.getInt('currentQuoteIndex') ?? 0;
    _updateDailyQuoteIfNeeded();
  }

  void _updateDailyQuoteIfNeeded() {
    final currentDate = DateTime.now();
    if (currentDate.difference(_lastQuoteChangeDate).inDays >= 1) {
      // Change to the next quote if a day has passed since the last change
      setState(() {
        _currentQuoteIndex = (_currentQuoteIndex + 1) % dailyQuotes.length;
      });

      // Store the updated quote index and date
      _prefs.setInt('currentQuoteIndex', _currentQuoteIndex);
      _prefs.setString('lastQuoteChangeDate', currentDate.toIso8601String());
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuote = dailyQuotes[_currentQuoteIndex];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity, // Make the container expand to the width of the screen
          decoration: BoxDecoration(
            color: Colors.white, // Use white color for the whiteboard background
            borderRadius: BorderRadius.circular(10.0), // Add rounded corners for a realistic look
            border: Border.all(
              color: Colors.black87, // Add a border to resemble the edges of a whiteboard
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Add a slight shadow for depth
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quotes of the Day!",
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 20, // Increase font size for the title
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  currentQuote,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0, // Add some letter spacing for a handwritten look
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
