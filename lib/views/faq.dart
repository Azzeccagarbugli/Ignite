import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ignite/widgets/faq_panels.dart';
import 'dart:convert';
import 'package:ignite/widgets/header.dart';
import 'package:theme_provider/theme_provider.dart';

class FAQ {
  String question;
  String answer;

  FAQ({
    @required this.question,
    @required this.answer,
  });

  factory FAQ.fromJson(Map<String, dynamic> parsedJson) {
    return FAQ(
      question: parsedJson['question'],
      answer: parsedJson['answer'],
    );
  }
}

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  Future<String> uploadAssets() async {
    return await rootBundle.loadString('assets/general/faq.json');
  }

  Future<List<FAQ>> loadFAQ() async {
    String jsonData = await uploadAssets();
    final faqsList = json.decode(jsonData).cast<Map<String, dynamic>>();
    return faqsList.map<FAQ>((json) => FAQ.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Header(
            title: 'F.A.Q',
            subtitle:
                'Di seguito sarà possibile consultare delle domande frequenti per comprendere meglio il funzionamento dell\'applicazione.',
            heroTag: 'icon_faq',
            icon: Icon(
              Icons.question_answer,
              size: 52.0,
              color: Colors.white,
            ),
          ),
          FutureBuilder<List<FAQ>>(
            future: loadFAQ(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new FAQPanel(
                  listFaqs: snapshot.data,
                );
              } else if (snapshot.hasError) {
                return new Container(
                  child: new Text(
                    'Si è verificato un errore nella lettura del file JSON della seguente natura: ${snapshot.error}.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                );
              } else {
                return new Container(
                  child: new Text(
                    'Si è verificato un errore nella lettura del file JSON.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
