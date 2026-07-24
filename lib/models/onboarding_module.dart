class OnBoardModel {
  String image;
  String text;
  String title;
  OnBoardModel({
    required this.image,
    required this.text,
    required this.title,
  });
}
List<OnBoardModel> screensModel = <OnBoardModel>[
  OnBoardModel(
    text: "Apply and manage your leaves with ease",
    title: "Smart Leave Management",
    image: 'assets/1.jpg',
  ),
  OnBoardModel(
    image: 'assets/2.jpg',
    text: "Check in and check out with a single tap",
    title: "Easy Attendance Tracking",
  ),
  OnBoardModel(
    image: 'assets/3.jpg',
    text: "View your complete attendance records anytime",
    title: "Attendance History",
  ),
];