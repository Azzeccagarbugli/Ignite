import 'package:flutter/material.dart';
import 'package:ignite/views/loading_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IntroductionTutorial extends StatelessWidget {
  const IntroductionTutorial({Key key}) : super(key: key);

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoadingScreen()),
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
      pages: [
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
          title: "Una community online",
          body:
              "Ignite non si limita solamente alla mappatura degli idranti ma può consentirti di aprire ticket online per entrare in contatto diretto con il commando di pompieri della tua città.",
          image: _buildImage('3'),
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
      globalBackgroundColor: Colors.red[600],
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
