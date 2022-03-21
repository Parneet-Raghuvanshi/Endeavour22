import 'package:endeavour22/drawermain/drawer_item.dart';

class DrawerItems {
  static const home = DrawerItem(title: 'Home', icon: 'assets/images/home.png');
  static const events =
      DrawerItem(title: 'Events', icon: 'assets/images/events.png');
  static const schedule =
      DrawerItem(title: 'Schedule', icon: 'assets/images/schedule.png');
  static const speakers =
      DrawerItem(title: 'Speakers', icon: 'assets/images/speaker.png');
  static const sponsors =
      DrawerItem(title: 'Sponsors', icon: 'assets/images/sponsor.png');
  static const team =
      DrawerItem(title: 'Team', icon: 'assets/images/group.png');
  static const aboutUs =
      DrawerItem(title: 'About Us', icon: 'assets/images/info.png');
  static const logout =
      DrawerItem(title: 'Logout', icon: 'assets/images/logout.png');

  static final List<DrawerItem> all = [
    home,
    events,
    schedule,
    speakers,
    sponsors,
    team,
    aboutUs,
    logout,
  ];
}
