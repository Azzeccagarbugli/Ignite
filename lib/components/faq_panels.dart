import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:ignite/views/faq.dart';

class FAQPanel extends StatelessWidget {
  final List<FAQ> listFaqs;

  FAQPanel({@required this.listFaqs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: listFaqs.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 10.0,
            bottom: 4.0,
          ),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: ExpandablePanel(
              header: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  listFaqs[index].question,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              expanded: Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    listFaqs[index].answer,
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
          ),
        );
      },
    );
  }
}
