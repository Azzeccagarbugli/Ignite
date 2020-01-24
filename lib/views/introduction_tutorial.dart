import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ignite/providers/auth_provider.dart';
import 'package:ignite/providers/db_provider.dart';
import 'package:ignite/views/fireman_screen_views/fireman_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'citizen_screen_views/citizen_screen.dart';

class IntroductionTutorial extends StatelessWidget {
  IntroductionTutorial({@required this.isFireman});

  final bool isFireman;

  void _onIntroEnd(context) async {
    Provider.of<DbProvider>(context).setFirstAccessToFalse(
        await Provider.of<AuthProvider>(context).getUser());
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => isFireman ? FiremanScreen() : CitizenScreen(),
      ),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: SvgPicture.asset(
        'assets/images/introduction/$assetName.svg',
        placeholderBuilder: (BuildContext context) => new Container(
          padding: const EdgeInsets.all(30.0),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white,
            ),
          ),
        ),
        width: 250.0,
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
      fontSize: 19.0,
      color: Colors.white,
    );
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(
        16.0,
        0.0,
        16.0,
        16.0,
      ),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      pages: isFireman
          ? [
              PageViewModel(
                title: "Benvenuto!",
                body:
                    "Inizia a mappare gli idranti della città per avere a disposizione una mappa interattiva utile nel lavoro di tutti i giorni.",
                image: _buildImage('2'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Lavorare non è mai stato così facile",
                body:
                    "Cliccando sul pulsante in alto a destra dello schermo potrai trovare l'idrante più vicino a te in un attimo!",
                image: _buildImage('1'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Richieste dei cittadini",
                body:
                    "Anche i cittadini potranno dare una mano ad inserire gli idranti grazie all'app. Non dovrai far altro che controllare, nell'apposita sezione, le richieste inviate e decidere se approvarle o meno.",
                image: _buildImage('5'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Condividi la tua idea di futuro con noi",
                body:
                    "Lascia volentiri dei feedback all'interno dei nostri canali social per dirci cosa ne pensi di questa fantastica applicazione!",
                image: _buildImage('4'),
                decoration: pageDecoration,
              ),
            ]
          : [
              PageViewModel(
                title: "Benvenuto!",
                body:
                    "Inizia a mappare gli idranti della tua città per contribuire all'intera comunità nazionale dei Vigili del Fuoco.",
                image: _buildImage('2'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Per un posto migliore",
                body:
                    "Utilizzando una vasta infrastruttura potremmo in futuro ampliare il sistema a livello mondiale.",
                image: _buildImage('1'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Condividi la tua idea di futuro con noi",
                body:
                    "Lascia volentiri dei feedback all'interno dei nostri canali social per dirci cosa ne pensi di questa fantastica applicazione!",
                image: _buildImage('4'),
                decoration: pageDecoration,
              ),
            ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      globalBackgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
      skip: const Text(
        'Salta',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
      done: const Text(
        'Fatto',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.white,
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.orangeAccent,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              25.0,
            ),
          ),
        ),
      ),
    );
  }
}
