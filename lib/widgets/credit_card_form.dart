import 'package:flutter/material.dart';
import 'credit_card_model.dart';
import 'credit_card_widget.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key? key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    required this.onCreditCardModelChange,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
  }) : super(key: key);

  final String? cardNumber;
  final String? expiryDate;
  final String? cardHolderName;
  final String? cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color? themeColor;
  final Color? textColor;
  final Color? cursorColor;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  String? cardNumber;
  String? expiryDate;
  String? cardHolderName;
  String? cvvCode;
  bool isCvvFocused = false;
  Color? themeColor;

  late void Function(CreditCardModel) onCreditCardModelChange;
  CreditCardModel? creditCardModel;

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel!.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel!);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel!.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel!);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel!.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel!);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel!.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel!);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel!.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel!);
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  Widget cardNumTextField() {
    return TextFormField(
      controller: _cardNumberController,
      cursorColor: widget.cursorColor ?? themeColor,
      style: TextStyle(
        color: widget.textColor,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Card number',
        hintText: 'xxxx xxxx xxxx xxxx',
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
    );
  }

// Text Field for expiry date
  Widget expiryDateTextField() {
    return TextFormField(
      controller: _expiryDateController,
      cursorColor: widget.cursorColor ?? themeColor,
      style: TextStyle(
        color: widget.textColor,
      ),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Expired Date',
          hintText: 'MM/YY'),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
    );
  }

// Text Field for cvv
  Widget cvvTextField() {
    return TextField(
      focusNode: cvvFocusNode,
      controller: _cvvCodeController,
      cursorColor: widget.cursorColor ?? themeColor,
      style: TextStyle(
        color: widget.textColor,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'CVV',
        hintText: 'XXXX',
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      onChanged: (String text) {
        setState(() {
          cvvCode = text;
        });
      },
    );
  }

// Text Field for cardholder
  Widget cardHolderTextField() {
    return TextFormField(
      controller: _cardHolderNameController,
      cursorColor: widget.cursorColor ?? themeColor,
      style: TextStyle(
        color: widget.textColor,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Card Holder',
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
    );
  }

// Credit card form
  Widget creditCardForm() {
    return Form(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: cardNumTextField(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
            child: expiryDateTextField(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
            child: cvvTextField(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
            child: cardHolderTextField(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor!.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: creditCardForm(),
    );
  }
}
