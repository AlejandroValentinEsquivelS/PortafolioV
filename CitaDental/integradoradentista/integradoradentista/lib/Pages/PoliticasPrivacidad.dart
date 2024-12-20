import 'package:flutter/material.dart';

class PoliticasPrivacidad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Políticas de Privacidad',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF2467ae),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  sectionTitle('Introducción'),
                  sectionText(
                      'En esta página se describen nuestras políticas sobre la recopilación, uso y divulgación de información cuando utilizas nuestro servicio.'),
                  sectionTitle('Recopilación de Información'),
                  sectionText(
                      'Recopilamos varios tipos de información para diversos fines, con el fin de ofrecer nuestro servicio.'),
                  sectionTitle('Uso de la Información'),
                  sectionText('Utilizamos la información que recopilamos para diversos fines, incluyendo:'),
                  bulletList([
                    'Proveer y mantener nuestro servicio',
                    'Notificarte sobre cambios en nuestro servicio',
                    'Permitir la participación en características interactivas de nuestro servicio',
                    'Proveer soporte al cliente',
                    'Recopilar análisis o información valiosa para mejorar nuestro servicio',
                    'Monitorear el uso de nuestro servicio',
                    'Detectar, prevenir y abordar problemas técnicos',
                  ]),
                  sectionTitle('Divulgación de la Información'),
                  sectionText('Podemos divulgar información personal que recopilamos, o que proporcionas:'),
                  bulletList([
                    'Para cumplir con una obligación legal',
                    'Para proteger y defender nuestros derechos o propiedad',
                    'Para prevenir o investigar posibles irregularidades en relación con el servicio',
                    'Para proteger la seguridad personal de los usuarios del servicio o del público',
                    'Para protegerse contra la responsabilidad legal',
                  ]),
                  sectionTitle('Seguridad de la Información'),
                  sectionText(
                      'La seguridad de tu información es importante para nosotros, pero recuerda que ningún método de transmisión a través de Internet, o método de almacenamiento electrónico, es 100% seguro. Si bien nos esforzamos por utilizar medios comercialmente aceptables para proteger tu información personal, no podemos garantizar su seguridad absoluta.'),
                  sectionTitle('Cambios a esta Política de Privacidad'),
                  sectionText(
                      'Podemos actualizar nuestra Política de Privacidad de vez en cuando. Te notificaremos sobre cualquier cambio publicando la nueva Política de Privacidad en esta página. Te aconsejamos que revises esta Política de Privacidad periódicamente para cualquier cambio. Los cambios a esta Política de Privacidad son efectivos cuando se publican en esta página.'),
                  sectionTitle('Contacto'),
                  sectionText('Si tienes alguna pregunta sobre esta Política de Privacidad, contáctanos:'),
                  bulletList([
                    'Por correo electrónico: info@tusitio.com',
                    'Por teléfono: +123 456 7890',
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFFF9F9F9),
    );
  }

  // Funciones de sección para reutilización
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2467ae),
        ),
      ),
    );
  }

  Widget sectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget bulletList(List<String> items) {
    return Column(
      children: items
          .map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• ', style: TextStyle(color: Color(0xFF2467ae), fontSize: 18)),
            Expanded(
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ))
          .toList(),
    );
  }
}