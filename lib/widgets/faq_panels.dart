import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:ignite/views/faq.dart';
import 'package:theme_provider/theme_provider.dart';

class FAQPanel extends StatelessWidget {
  final List<FAQ> listFaqs;

  FAQPanel({@required this.listFaqs});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
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
                  child: ExpandableNotifier(
                    child: ScrollOnExpand(
                      scrollOnExpand: true,
                      child: ExpandablePanel(
                        header: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            listFaqs[index].question,
                            style: TextStyle(
                              color: ThemeProvider.themeOf(context)
                                  .data
                                  .primaryColor,
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
                                color: Colors.grey[900],
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
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
