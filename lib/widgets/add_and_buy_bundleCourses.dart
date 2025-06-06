import 'package:flutter_translate/flutter_translate.dart';
import '../provider/cart_pro_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/bottom_navigation_screen.dart';
import './triangle.dart';

class AddAndBuyBundle extends StatefulWidget {
  final int? bundleId;
  final dynamic bprice;
  AddAndBuyBundle(this.bundleId, this.bprice);
  @override
  _AddAndBuyBundleState createState() => _AddAndBuyBundleState();
}

class _AddAndBuyBundleState extends State<AddAndBuyBundle> {
  bool isloading = false;

  Widget triangeShape() {
    return CustomPaint(
      painter: TrianglePainter(
        strokeColor: Colors.white,
        strokeWidth: 4,
        paintingStyle: PaintingStyle.fill,
      ),
      child: Container(
        height: 20,
      ),
    );
  }

  Widget addToCartButton(bool inCart) {
    CartApiCall crt = new CartApiCall();
    return InkWell(
      onTap: () async {
        setState(() {
          this.isloading = true;
        });
        setState(() {});
        if (!inCart) {
          bool success =
              await crt.addToCartBundle(widget.bundleId.toString(), context);
          if (success)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  translate("Bundle_added_to_cart"),
                ),
              ),
            );
          else
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  translate("Bundle_addition_to_cart_failed"),
                ),
              ),
            );
        } else
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyBottomNavigationBar(
                        pageInd: 3,
                      )));
        setState(() {
          this.isloading = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: 55.0,
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(
            color: Colors.purple,
            border: Border.all(width: 1.0, color: Colors.black12),
            borderRadius: BorderRadius.circular(10.0)),
        child: Stack(
          children: [
            Center(
              child: this.isloading
                  ? CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      inCart
                          ? translate("GO_TO_CART")
                          : translate("ADD_TO_CART"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            Positioned(
              right: 0,
              top: 4,
              child: Container(
                margin: EdgeInsets.all(3.0),
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.00),
                ),
                child: Image.asset(
                  "assets/icons/addtocart.png",
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool buynowLoading = false;
  Widget buyNowButton(bool inCart) {
    return InkWell(
      onTap: () async {
        setState(() {
          this.buynowLoading = true;
        });
        if (!inCart) {
          bool success = await CartApiCall()
              .addToCartBundle(widget.bundleId.toString(), context);
          if (success) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyBottomNavigationBar(
                  pageInd: 3,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  translate("Something_went_wrong"),
                ),
              ),
            );
          }
        } else
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyBottomNavigationBar(
                pageInd: 3,
              ),
            ),
          );
        setState(() {
          this.buynowLoading = false;
        });
      },
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width - 50,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1.0, color: Colors.black12),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            Center(
              child: buynowLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    )
                  : Text(
                      translate("BUY_NOW"),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
            ),
            Positioned(
              right: 0,
              top: 4,
              child: Container(
                margin: EdgeInsets.all(3.0),
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.00),
                ),
                child: Image.asset(
                  "assets/icons/buynow.png",
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buttonContainer(bool inCart) {
    return Container(
      height: MediaQuery.of(context).size.height /
          (MediaQuery.of(context).orientation == Orientation.landscape
              ? 1.5
              : 3.9),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      margin: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          addToCartButton(inCart),
          SizedBox(
            height: 5.0,
          ),
          buyNowButton(inCart),
          SizedBox(
            height: 5.0,
          ),
          Text(
            translate("30days_MoneyBack_Guarantee"),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12.0),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool inCart =
        Provider.of<CartProducts>(context).checkBundle(widget.bundleId);
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          children: [triangeShape(), buttonContainer(inCart)],
        ),
      ),
    );
  }
}
