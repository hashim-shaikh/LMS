import 'package:chandrakalm/Widgets/appbar.dart';
import 'package:chandrakalm/model/content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:chandrakalm/common/theme.dart' as T;
import 'package:provider/provider.dart';
import '../bottom_navigation_screen.dart';

class CheckQuizResult extends StatelessWidget {
  final List<QuizQuestion>? questions;
  final Map<int, dynamic>? answers;

  const CheckQuizResult(
      {Key? key, @required this.questions, @required this.answers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
      backgroundColor: mode.backgroundColor,
      appBar: customAppBar(context, translate("Quiz_Result")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: questions!.length + 1,
        itemBuilder: _buildItem,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    T.Theme mode = Provider.of<T.Theme>(context);
    if (index == questions!.length) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: mode.easternBlueColor,
          ),
          child: Text(
            translate("Home_"),
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            var route = new MaterialPageRoute(
              builder: (BuildContext context) => MyBottomNavigationBar(
                pageInd: 0,
              ),
            );
            Navigator.push(context, route);
          },
        ),
      );
    }
    QuizQuestion question = questions![index];
    bool correct = question.correct == answers![index];
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 25.0,
              offset: Offset(0.0, 20.0),
              spreadRadius: -15.0)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            HtmlUnescape().convert(question.question.toString()),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16.0),
          ),
          SizedBox(height: 5.0),
          Text(
            HtmlUnescape().convert("${answers![index]}"),
            style: TextStyle(
                color: correct ? Colors.green : Colors.purple,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          correct
              ? Container()
              : Text.rich(
                  TextSpan(children: [
                    TextSpan(text: "${translate("Answer_")}: "),
                    TextSpan(
                        text: HtmlUnescape().convert(question.correct.toString()),
                        style: TextStyle(fontWeight: FontWeight.w500))
                  ]),
                  style: TextStyle(fontSize: 16.0),
                )
        ],
      ),
    );
  }
}
