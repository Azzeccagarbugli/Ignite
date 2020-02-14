import 'package:flutter/material.dart';
import 'package:ignite/widgets/remove_glow.dart';
import 'package:theme_provider/theme_provider.dart';

class BuildSectionFilter extends StatefulWidget {
  final Set<String> listValue;
  final String nameSection;
  final String descValue;
  final Icon icon;
  final Function value;
  BuildSectionFilter({
    @required this.listValue,
    @required this.nameSection,
    @required this.descValue,
    @required this.icon,
    @required this.value,
  });

  @override
  _BuildSectionFilterState createState() => _BuildSectionFilterState();
}

class _BuildSectionFilterState extends State<BuildSectionFilter> {
  int _selectedIndex = 0;

  _onSelected(int index) {
    _selectedIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 2,
            ),
            child: Row(
              children: <Widget>[
                Chip(
                  backgroundColor: Colors.white,
                  elevation: 3,
                  label: Text(
                    this.widget.nameSection,
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeProvider.themeOf(context).id == "main"
                          ? Colors.red
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100.0,
            child: ScrollConfiguration(
              behavior: RemoveGlow(),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.listValue.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      width: 200,
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(color: Colors.red, width: 2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        color: ThemeProvider.themeOf(context).id == "main"
                            ? (_selectedIndex != null && _selectedIndex == i
                                ? Colors.red
                                : Colors.white)
                            : (_selectedIndex != null && _selectedIndex == i
                                ? Colors.black
                                : Colors.white),
                        child: ListTile(
                          title: Text(
                            widget.listValue.elementAt(i),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ThemeProvider.themeOf(context).id == "main"
                                  ? (_selectedIndex != null &&
                                          _selectedIndex == i
                                      ? Colors.white
                                      : Colors.red)
                                  : (_selectedIndex != null &&
                                          _selectedIndex == i
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                          subtitle: Text(
                            this.widget.descValue,
                            style: TextStyle(
                              color:
                                  _selectedIndex != null && _selectedIndex == i
                                      ? Colors.grey[100]
                                      : Colors.grey[600],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _onSelected(i);
                              widget.value(widget.listValue.elementAt(i));
                            });
                          },
                          leading: CircleAvatar(
                            backgroundColor:
                                ThemeProvider.themeOf(context).id == "main"
                                    ? Colors.red
                                    : Colors.grey[600],
                            child: this.widget.icon,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
