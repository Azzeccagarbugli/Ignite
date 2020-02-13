<p align="center">
  <img src="Frontend/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" style="max-width: 20%">
</p>

---

<p align="center">
<img src="https://forthebadge.com/images/badges/built-with-love.svg"/>
<img src="https://forthebadge.com/images/badges/built-for-android.svg"/>
<img src="https://forthebadge.com/images/badges/cc-0.svg"/><br><br>
    <b>Ignite</b>, progetto realizzato in <b>Flutter</b> per il corso di laurea <b>L-31</b> presso <b>Unicam</b>, <i>nell'anno accademico 2019/2020</i>, realizzato dagli studenti Francesco Coppola, Francesco Pio Stelluti e Luca Cervioni per l'esame di <b>Programmazione Web App e Mobile</b> seguendo i canoni di sviluppo proposti
    <br><br><b>
<a href="https://www.unicam.it/">• Unicam</a>
<a href="http://francescocoppola.me/Ignite-Homepage/">• Sito web</a>
<a href="https://it.wikipedia.org/wiki/Licenza_MIT">• Licenza</a>
</b></p>

# Tabella dei contenuti

- [Panoramica e funzionalità di base](#panoramica)
- [Tecnologie di base](#tecno)
- [Sito web completo e autori](#autori)

# Panoramica e funzionalità di base <a name = "panoramica"></a>

L’obiettivo principale dell’applicativo sviluppato è quello di porsi come **strumento di assistenza** per il lavoro ordinario operato dai **Vigili del Fuoco**.

Le funzionalità principali dell'applicativo, **conoscere la locazione ed i dettagli degli idranti segnalati nel suolo italiano ed effettuare nuove segnalazioni**, sono disponibili sia per i dipendenti Vigili del Fuoco iscritti al servizio che per i cittadini che si sono registrati presso tale servizio. La differenza principale nelle funzionalità offerte ai due tipi di utenti a cui è rivolto l'applicativo sta nel livello di affidabilità che viene assegnato alle segnalazioni della presenza di idranti che vengono effettuate. 

Se un dipendente Vigile del Fuoco effettua la segnalazione della presenza di un idrante tale segnalazione viene automaticamente considerata come valida e consultabile a tutti gli utenti che dispongongono dell'accesso al servizio. Se la segnalazione proviene da un cittadino comune allora questa dovrà essere analizzata, arricchita con ulteriori informazioni e approvata da un dipendente Vigile del Fuoco che ha accesso al servizio. Nello specifico, ogni dipendente Vigile del Fuoco che ha effettuato l'accesso al servizio potrà approvare le segnalazioni relative ad idranti presenti entro una specifica distanza. 

Per quanto concerne la registrazione di nuovi utenti, si è deciso di rendere la registrazione tramite applicativo una prerogativa degli utenti cittadini. L'iscrizione al servizio per gli addetti Vigili del Fuoco è effettuabile tramite una dashboard, indipendente dall'applicativo di base ma che condivide con esso i dati su cui operano. Tra le altre funzionalità della dashboard rientrano l'aggiunta delle informazioni relative alle caserme dei Vigili del Fuoco presenti nel territorio italiano, la gestione dei privilegi associati agli utenti iscritti al servizio e la rimozioni dei singoli idranti già segnalati ed approvati.

# Tecnologie di base <a name = "tecno"></a>

Il lato frontend dell’applicativo si rivolge al mondo Android ed è stato sviluppato in un linguaggio di programmazione chiamato **Dart** mediante il framework Open Source **Flutter**. 

La prima implementazione della logica dell'implementazione è stata effettuata all'interno dell'applicativo stesso. Ci si è affidati all'interazione con i servizi di database NoSQL **Firestore** per quanto riguarda la persistenza dei dati, che sono stati elaborati e gestiti direttamente all'interno del linguaggio Dart.

Una seconda implementazione della logica si basata su un backend scritto in linguaggio **Java**. L'interazione tra frontend e backend è stata resa possibile grazie alla creazione di **API Rest**, la cui scrittura e gestione, anche sotto l'ottica della sicurezza, sono state rese possibili grazie al framework **Spring Boot**. Per la persistenza dei dati del servizio ci si è affidati al database NoSQL **MongoDB**. Per poter rendere più agevole la scrittura del codice tramite l'uso di annotazioni, si è deciso di impiegare la libreria Java **Lombok**.

[Qui](https://docs.google.com/document/d/1IBhf9xksPD4AwHsbAoBzN1ue7LrSgzB2EBK0UFNTidI/edit?usp=sharing) è possibile trovare tutte le chiamate API Rest sviluppate con Java.


Per quanto concerne l'autenticazione degli utenti al servizio si è deciso di affidarsi ai servizi di **Google Firebase**, non correlati a quella che è la logica di backend dell'applicativo.
Basandosi su Firebase per quanto riguarda l'autenticazione, abbiamo deciso di impiegare il sistema **Basic Auth** per aggiungere un essenziale strato di sicurezza alle chiamate del backend Java tramite **Spring Security**. Ogni chiamata alle Api è filtrata secondo il ruolo assegnato alla mail passata tramite Basic Auth (la password è comune per ogni ruolo). I ruoli sono in totale tre: Admin (**ADMIN**), Cittadino (**CITIZEN**), Dipendente VVF (**Fireman**).

La dashboard di amministrazione, raggiungibile tramite il seguente [indirizzo](https://ignitedashboard.netlify.com/), è stata sviluppata in **Vue.js**. Essa si interfaccia, al momento, con i dati a cui è possibile accedere tramite **Firestore** ed il suo funzionamento effettivo è quindi da riferirsi alla prima implementazione della logica dell'applicazione.

# Sito web completo e autori <a name = "autori"></a>

- [Sito web riassuntivo](http://francescocoppola.me/Ignite-Homepage/)
- [Dashboard](https://ignitedashboard.netlify.com/)

- [Francesco Coppola](https://github.com/azzeccagarbugli)
- [Francesco Pio Stelluti](https://github.com/FrancisFire)
- [Luca Cervioni](https://github.com/lucacervo98)
