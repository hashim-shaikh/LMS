import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../model/faq_model.dart';
import 'package:flutter/material.dart';
import '../services/http_services.dart';

class FaqView extends StatefulWidget {
  @override
  _FaqViewState createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  Widget html(htmlContent, clr, size) {
    return HtmlWidget(
      htmlContent,
      textStyle: TextStyle(
        fontSize: size,
        color: clr,
      ),
      customStylesBuilder: (element) {
        return {'font-weight': '600', 'font-size': '16', 'align': 'justify'};
      },
    );
  }

  List<Widget> _buildExpansionTileChildren(index, faq) => [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: html(
              faq[index].details, Color(0xff3F4654).withOpacity(0.7), 16.0),
        ),
      ];
  int idx = -1;

  Widget expansionTile(index, faq) {
    return ExpansionTile(
      backgroundColor: Color.fromRGBO(50, 150, 220, 0.05),
      trailing: SizedBox.shrink(),
      initiallyExpanded: idx == index,
      onExpansionChanged: (value) {
        if (value) {
          setState(() {
            idx = index;
          });
        } else {
          setState(() {
            idx = -1;
          });
        }
      },
      title: Text(
        ''
        '${faq[index].title}',
        style: TextStyle(
            color: Color(0xff3F4654),
            fontSize: 18,
            fontWeight: FontWeight.w600),
      ),
      children: _buildExpansionTileChildren(index, faq),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FaqElement>>(
      future: HttpService().fetchUserFaq(),
      builder:
          (BuildContext context, AsyncSnapshot<List<FaqElement>> snapshot) {
        return !snapshot.hasData
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : Scaffold(
                backgroundColor: Color(0xFFF1F3F8),
                body: Container(
                  height: 3000,
                  child: ListView.builder(
                    key: Key('builder ${idx.toString()}'),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    itemBuilder: (BuildContext context, int index) =>
                        expansionTile(index, snapshot.data),
                  ),
                ),
              );
      },
    );
  }
}
