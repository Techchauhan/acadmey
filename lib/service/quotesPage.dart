import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({Key? key}) : super(key: key);

  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  late SharedPreferences _prefs;
  late DateTime _lastQuoteChangeDate;
  late int _currentQuoteIndex = 0;

  final List<String> dailyQuotes = [
  '“The only way to do great work is to love what you do.” - Steve Jobs',
  '“In three words I can sum up everything I’ve learned about life: it goes on.” - Robert Frost',
  '“You miss 100% of the shots you don’t take.” - Wayne Gretzky',
  '“The greatest glory in living lies not in never falling, but in rising every time we fall.” - Nelson Mandela',
 " '“Life is what happens when you're busy making other plans.” - John Lennon',"
  '“The only thing necessary for the triumph of evil is for good men to do nothing.” - Edmund Burke',
  '“To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment.” - Ralph Waldo Emerson',
  '“The best way to predict the future is to create it.” - Peter Drucker',
  '“Success is not final, failure is not fatal: it is the courage to continue that counts.” - Winston Churchill',
  "'“Two things are infinite: the universe and human stupidity; and I'm not sure about the universe.” - Albert Einstein',"
  '“The only thing we have to fear is fear itself.” - Franklin D. Roosevelt',
  '“In the end, we will remember not the words of our enemies, but the silence of our friends.” - Martin Luther King Jr.',
  "'“Don't cry because it's over, smile because it happened.” - Dr. Seuss',"
  '“The road to hell is paved with adverbs.” - Stephen King',
  '“To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment.” - Ralph Waldo Emerson',
  '“The only way to do great work is to love what you do.” - Steve Jobs',
  '“In three words I can sum up everything I’ve learned about life: it goes on.” - Robert Frost',
  '“You miss 100% of the shots you don’t take.” - Wayne Gretzky',
  '“The greatest glory in living lies not in never falling, but in rising every time we fall.” - Nelson Mandela',
  " '“Life is what happens when you're busy making other plans.” - John Lennon',"
  '“The only thing necessary for the triumph of evil is for good men to do nothing.” - Edmund Burke',
  '“To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment.” - Ralph Waldo Emerson',
  '“The best way to predict the future is to create it.” - Peter Drucker',
  '“Success is not final, failure is not fatal: it is the courage to continue that counts.” - Winston Churchill',
  "'“Two things are infinite: the universe and human stupidity; and I'm not sure about the universe.” - Albert Einstein',"
  '“The only thing we have to fear is fear itself.” - Franklin D. Roosevelt',
  "“Don't cry because it's over, smile because it happened.” - Dr. Seuss',"
  '“In the end, we will remember not the words of our enemies, but the silence of our friends.” - Martin Luther King Jr.',
  '“The road to hell is paved with adverbs.” - Stephen King',

  // Add more quotes here
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    _lastQuoteChangeDate = DateTime.parse(
        _prefs.getString('lastQuoteChangeDate') ?? DateTime.now().toIso8601String());
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
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.black87,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
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
                    fontSize: 20,
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
                    letterSpacing: 1.0,
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
