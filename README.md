**Nome:** Lorenzo Calisti

**Matricola:** 307458

[![ASPDM Project CI](https://github.com/Supercaly/ASDM-Project/workflows/ASPDM%20Project%20CI/badge.svg)](https://github.com/Supercaly/ASPDM-Project/actions)
[![codecov](https://codecov.io/gh/Supercaly/ASPDM-Project/branch/master/graph/badge.svg?token=J4P3RO1ZCL)](https://codecov.io/gh/Supercaly/ASPDM-Project)

# Tasky

Tasky è un'applicazione pensata per gestire e tenere traccia dell'andamento dei progetti all'interno di una azienda o un ufficio.

L'applicazione permette ai propri utenti di creare un piccolo promemoria,detto ***task***, e di vedere i task creati dai propri colleghi. Un task è composto da un *titolo*, una *descrizione*, una *data di scadenza*, delle *label*, dei *membri* e delle *checklist*, tutti elementi molto utili per tenere traccia delle cose sa fare o di vari problemi riscontrati nella propria area di lavoro. 

Un esempio di task per cui tasky è stata pensata è quello di indicare la realizzazione di una determiata funzionalità a cui la compagnia sta lavorando; in queso caso torna molto utile poter inserire una data di scadenza entro la quale il lavoro dev'essere completato, delle label per marcare l'alta priorità del progettoe una lista di utenti **membri** indicati come i responsabili di questa feature, inoltre è possibile inserire una o più checklist con delle liste di cose da fare che possono essere spuntate man mano che il lavoro procede. Infine, sapendo quanto i feedback dei propri colleghisiano importanti, ogni utente ha la possibilità di aggiungere un proprio commento sotto ogni task, creando un area di discussione vera e propia.

## Getting Started

Prima di scaricare e compilare il progetto è importante prendere nota dei seguenti requisiti:

### Versione di flutter

L'applicazione è stata progettata e testata utilizzando flutter con il canale `beta` alla versione `1.26.0-17.3.pre`. Per ottenere la corretta versione di flutter eseguire i seguenti comandi nel terminale:
```console
$ flutter channel beta
$ flutter upgrade
```
### Code generation

L'applicazione fa utilizzo di pacchetti che richiedono la generazione di codice per funzionare, per facilitare questa parte sono stati creati degli script che automatizzano il processo.

**Linux:**
```console
$ ./script/linux/generate_colors.sh
$ ./script/linux/generate_model.sh
$ ./script/linux/generate_icons.sh
```
**Windows:**
```console
> ./script/windows/generate_colors.bat
> ./script/windows/generate_model.bat
> ./script/windows/generate_icons.bat
```

### Nota per il web

A volte quando si prova ad eseguire l'applicazione utilizzando flutter web può succedere di incappare nel seguente errore:

```
Attempting to connect to browser instance..
Finished with error: Failed to establish connection with the application instance in Chrome.
This can happen if the websocket connection used by the web tooling is unabled to correctly establish a connection, for example due to a firewall.
```

Questo è dovuto ad un [bug](https://github.com/flutter/flutter/issues/49482) di flutter web che spesso si risolve ri-eseguendo il progetto nuovamente oppure compilandolo in modalità di release con il comando `flutter run -d web --release`.
