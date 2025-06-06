import 'package:chandrakalm/localization/language_provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../provider/filter_pro.dart';
import '../common/theme.dart' as T;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  AppBar app(Color bgColor, Color txtColor) {
    return AppBar(
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: txtColor,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: bgColor,
      title: Text(
        translate("Filters_"),
        style: TextStyle(color: txtColor, fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
            icon: Icon(
              Icons.delete,
              color: txtColor,
            ),
            onPressed: () {
              FilterDetailsProvider details =
                  Provider.of<FilterDetailsProvider>(context, listen: false);
              details.setdefault();
              setState(() {});
            })
      ],
    );
  }

  Widget costRangeSlider(RangeValues values) {
    return RangeSlider(
        min: 0,
        max: 1000,
        activeColor: Colors.purple,
        inactiveColor: Colors.grey,
        values: values,
        onChanged: (value) {
          setState(() {
            _values = value;
            FilterDetailsProvider details =
                Provider.of<FilterDetailsProvider>(context, listen: false);
            details.minprice = value.start.toInt();
            details.maxprice = value.end.toInt();
          });
        });
  }

  Widget rangelabels(Color txtColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _values.start.toInt().toString(),
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 16, color: txtColor),
          ),
          Text(
            _values.end.toInt().toString(),
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 16, color: txtColor),
          ),
        ],
      ),
    );
  }

  Widget title(String txt) {
    return Container(
      margin: EdgeInsets.only(left: 12, top: 10, bottom: 15),
      child: Text(
        txt,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xff0083A4)),
      ),
    );
  }

  List<String>? dura;
  List<Widget> builddurations(int val, Color txtColor) {
    List<Widget> ans = [];
    int idx = 0;
    dura!.forEach((element) {
      ans.add(RadioListTile(
          title: Text(
            element,
            style: TextStyle(color: txtColor),
          ),
          selected: val == idx,
          value: idx,
          groupValue: val,
          onChanged: (value) {
            setState(() {
              valueDur = value!;
              FilterDetailsProvider details =
                  Provider.of<FilterDetailsProvider>(context, listen: false);
              details.durationval = value;
            });
          }));
      idx += 1;
    });
    return ans;
  }

  Widget scaffoldBody(Color txtcolor, FilterDetailsProvider details) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            title(translate("Cost_")),
            Container(
              height: 70,
              child: Column(
                children: [
                  rangelabels(txtcolor),
                  RangeSlider(
                    values: RangeValues(
                        details.minprice * 1.0, details.maxprice * 1.0),
                    min: 0,
                    max: 100000,
                    activeColor: Colors.purple,
                    inactiveColor: Colors.grey,
                    onChanged: (values) {
                      setState(() {
                        FilterDetailsProvider details =
                            Provider.of<FilterDetailsProvider>(context,
                                listen: false);
                        details.minprice = values.start.toInt();
                        details.maxprice = values.end.toInt();
                      });
                    },
                  )
                ],
              ),
            ),
            title(translate("Duration_")),
            Container(
              height: 56.0 * dura!.length,
              child: Column(
                children: builddurations(details.durationval, txtcolor),
              ),
            ),
            Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  translate("Apply_"),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  RangeValues _values = RangeValues(0, 1000);
  int valueDur = -1;

  LanguageProvider? languageProvider;

  @override
  void initState() {
    super.initState();
    languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    dura = [
      "0-2 ${translate("hours_")}",
      "3-6 ${translate("hours_")}",
      "6+ ${translate("hours_")}"
    ];
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    FilterDetailsProvider details = Provider.of<FilterDetailsProvider>(context);
    _values = RangeValues(details.minprice * 1.0, details.maxprice * 1.0);
    return Scaffold(
      backgroundColor: mode.bgcolor,
      appBar: app(mode.bgcolor, mode.txtcolor),
      body: scaffoldBody(mode.txtcolor, details),
    );
  }
}
