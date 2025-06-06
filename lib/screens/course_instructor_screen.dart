import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../Widgets/html_text.dart';
import '../Widgets/instructor_courses.dart';
import '../common/apidata.dart';
import '../model/instructor_model.dart';
import 'package:flutter/material.dart';
import '../Widgets/utils.dart';

class CourseInstructorScreen extends StatefulWidget {
  final String imageUrl = "assets/placeholder/avatar.png";

  @override
  _CourseInstructorScreenState createState() => _CourseInstructorScreenState();
}

class _CourseInstructorScreenState extends State<CourseInstructorScreen> {
  var n = 3;

  Widget detailsSection(Instructor details) {
    int exp = (DateTime.now().year - details.user!.createdAt!.year);
    return SliverToBoxAdapter(
      child: Container(
        color: Color(0xff292C3F),
        height: MediaQuery.of(context).size.height /
            (MediaQuery.of(context).orientation == Orientation.landscape
                ? 0.7
                : 2.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 2.0,
            ),
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0),
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(color: Colors.white10, width: 5),
                      ),
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: details.user!.userImg == null
                            ? Image.asset(widget.imageUrl) as ImageProvider
                            : CachedNetworkImageProvider(
                                APIData.userImage + details.user!.userImg.toString(),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3.0,
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      details.user!.fname! + " " + details.user!.lname.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    Text(
                      details.user?.address== null ? '' : details.user!.address.toString(),
                      style: TextStyle(color: val),
                    ),
                    Text(
                      exp == 0
                          ? translate("less_than_one_year_experience")
                          : exp.toString() +
                              " ${translate("years_experience")}",
                      style: TextStyle(color: val),
                    ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: MediaQuery.of(context).size.height /
                    (MediaQuery.of(context).orientation == Orientation.landscape
                        ? 1.7
                        : 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 5.0),
                          height: 80.0,
                          width: MediaQuery.of(context).size.width / 2 - 50,
                          decoration: BoxDecoration(),
                          child: func(
                              details.courseCount.toDouble(),
                              translate("Courses_"),
                              0,
                              data[0],
                              Color(0xffB5B8C7),
                              1),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5.0),
                          height: 80.0,
                          width: MediaQuery.of(context).size.width / 2 - 50,
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(
                                color: Color(0xff383C4A), width: 1.5),
                          )),
                          child: func(
                              details.enrolledUser.toDouble(),
                              translate("Students_"),
                              1,
                              data[1],
                              Color(0xffB5B8C7),
                              1),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 3.0,
            )
          ],
        ),
      ),
    );
  }

  Widget aboutTheInstructor(Instructor details) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate("About_The_Instructor"),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0083A4),
                  ),
                ),
              ],
            ),
            html(details.user!.detail, Colors.grey[500]!, 15),
          ],
        ),
      ),
    );
  }

  Widget allCoursesHeading(int noOfCourses) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(translate("All_Courses"),
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0083A4))),
            Container(
              padding: EdgeInsets.only(top: 5.0),
              width: 50.0,
              height: 30.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                noOfCourses.toString(),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color val = Color(0xffB5B8C7);

  @override
  Widget build(BuildContext context) {
    Instructor details = ModalRoute.of(context)!.settings.arguments as Instructor;
    return Scaffold(
      body: Container(
        color: Color(0xffE5E5EF),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: Color(0xff292C3F),
                height: MediaQuery.of(context).padding.top,
              ),
            ),
            detailsSection(details),
            aboutTheInstructor(details),
            allCoursesHeading(details.courseCount),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, idx) => InstructCourses(details.course![idx]),
                childCount: details.course!.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

List<String> data = [
  "assets/icons/lecturesicon.png",
  "assets/icons/studentsicon.png",
  "assets/icons/star_icon.png",
  ""
];
