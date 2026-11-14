import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const QuoteApp());

class Quote {
  final String text;
  final String author;
  const Quote(this.text, this.author);
  String get full => '"$text"\n- $author';
}

const List<Quote> allQuotes = [
  Quote("The best way to predict the future is to create it.", "Peter Drucker"),
  Quote("Believe you can and you're halfway there.", "Theodore Roosevelt"),
  Quote("It always seems impossible until it's done.", "Nelson Mandela"),
  Quote("Stay hungry, stay foolish.", "Steve Jobs"),
  Quote("Dream big, start small, act now.", "Unknown"),
  Quote("Success is the sum of small efforts repeated daily.", "R. Collier"),
  Quote("Do something today that your future self will thank you for.", "Unknown"),
  Quote("The only way to do great work is to love what you do.", "Steve Jobs"),
];

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote of the Day',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Quote> favorites = [];
  late Quote current;

  @override
  void initState() {
    super.initState();
    current = quoteOfTheDay(); // refreshes automatically on every launch/day
  }

  Quote quoteOfTheDay() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return allQuotes[dayOfYear % allQuotes.length];
  }

  void newRandomQuote() {
    Quote next;
    do {
      next = allQuotes[Random().nextInt(allQuotes.length)];
    } while (next == current && allQuotes.length > 1);
    setState(() => current = next);
  }

  bool get isFavorite => favorites.contains(current);

  void toggleFavorite() {
    setState(() {
      isFavorite ? favorites.remove(current) : favorites.add(current);
    });
    _snack(isFavorite ? 'Added to favorites' : 'Removed from favorites');
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  void shareQuote() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share quote',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _shareChip('WhatsApp', Icons.chat, Colors.green),
                _shareChip('Instagram', Icons.camera_alt, Colors.pink),
                _shareChip('Telegram', Icons.send, Colors.blue),
                _shareChip('Messages', Icons.sms, Colors.orange),
                _shareChip('Copy', Icons.copy, Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _shareChip(String label, IconData icon, Color color) {
    return ActionChip(
      avatar: Icon(icon, color: color, size: 20),
      label: Text(label),
      onPressed: () {
        Clipboard.setData(
            ClipboardData(text: '${current.full}\n#QuoteOfTheDay'));
        Navigator.pop(context);
        _snack(label == 'Copy'
            ? 'Quote copied!'
            : 'Quote copied. Paste it in $label!');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateText = '${today.day}/${today.month}/${today.year}';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Quote of the Day',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        Text(dateText,
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                    IconButton(
                      icon: Badge(
                        isLabelVisible: favorites.isNotEmpty,
                        label: Text('${favorites.length}'),
                        child: const Icon(Icons.favorite,
                            color: Colors.white, size: 30),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FavoritesPage(
                            favorites: favorites,
                            onChanged: () => setState(() {}),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Column(
                            key: ValueKey(current.text),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.format_quote,
                                  size: 48, color: Colors.deepPurple),
                              const SizedBox(height: 12),
                              Text(
                                current.text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontStyle: FontStyle.italic,
                                    height: 1.4),
                              ),
                              const SizedBox(height: 20),
                              Text('- ${current.author}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.deepPurple)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionButton(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      'Favorite',
                      toggleFavorite,
                      color: isFavorite ? Colors.redAccent : Colors.deepPurple,
                    ),
                    _actionButton(Icons.share, 'Share', shareQuote),
                    _actionButton(Icons.refresh, 'New', newRandomQuote),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap,
      {Color color = Colors.deepPurple}) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: label,
          backgroundColor: Colors.white,
          onPressed: onTap,
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

class FavoritesPage extends StatefulWidget {
  final List<Quote> favorites;
  final VoidCallback onChanged;
  const FavoritesPage(
      {super.key, required this.favorites, required this.onChanged});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    final favs = widget.favorites;
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorite Quotes')),
      body: favs.isEmpty
          ? const Center(child: Text('No favorites yet. Tap the heart!'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favs.length,
              itemBuilder: (_, i) => Card(
                child: ListTile(
                  leading: const Icon(Icons.format_quote,
                      color: Colors.deepPurple),
                  title: Text(favs[i].text),
                  subtitle: Text('- ${favs[i].author}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      setState(() => favs.removeAt(i));
                      widget.onChanged();
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
