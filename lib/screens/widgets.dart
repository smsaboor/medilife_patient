
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfile{
  static String urlImage =
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80';
}

class GlobalAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Container()),
            );
          },
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-1.0, 0.0),
            end: const Alignment(1.0, 0.0),
            colors: [
              Theme.of(context).primaryColorLight,
              Theme.of(context).primaryColorDark,
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class StandardAppBar extends StatelessWidget with PreferredSizeWidget {
  const StandardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-1.0, 0.0),
            end: const Alignment(1.0, 0.0),
            colors: [
              Theme.of(context).primaryColorLight,
              Theme.of(context).primaryColorDark,
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class GlobalDrawer extends StatefulWidget {
  const GlobalDrawer({super.key});

  @override
  _GlobalDrawerState createState() => _GlobalDrawerState();
}

class _GlobalDrawerState extends State<GlobalDrawer> {

  launchURL(url) async {
  }

  getSpecialties() async {
  }

  Widget specialtyDrawerItem(
      {String? specialtyName,
      String? specialtyDoctorCount,
      String? specialtyImagePath}) {
    return ListTile(
      leading: Image.network(
        specialtyImagePath!,
        height: 25,
        width: 25,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(specialtyName ?? "not_found"),
          Container(
            width: 35,
            height: 35,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0x156aa6f8)),
            child: Align(
              alignment: Alignment.center,
              child: Text(specialtyDoctorCount ?? "0"),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Container(),
            ));
      },
    );
  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSpecialties();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 170.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-1.0, 0.0),
                end: const Alignment(1.0, 0.0),
                colors: [
                  Theme.of(context).primaryColorLight,
                  Theme.of(context).primaryColorDark,
                ],
              ),
            ),
            child: DrawerHeader(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      right: 15.0,
                    ),
                    width: 50.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: UserProfile.urlImage != null
                          ? CachedNetworkImage(
                              imageUrl: UserProfile.urlImage,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Image.asset('assets/images/user.jpg'),
                            )
                          : (Container()),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: FractionalOffset.centerLeft,
                          child: UserProfile != null
                              ? Text(
                                  'Welcome back, ${UserProfile.urlImage}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                )
                              : const Text(
                                  'Welcome back, null',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                        ),
                        const Align(
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            'How can we help you today?',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xaafffffff),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Container()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('My Health'),
            onTap: () {
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Top Doctors'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Container()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('All Doctors'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Container()),
              );
            },
          ),
          const  ExpansionTile(
            leading:  Icon(Icons.mood),
            title:  Text("Browse by Specialty"),
            children: <Widget>[
            ],
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Doctor Lookup'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Container()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.web),
            title: const Text('Visit my Website'),
            onTap: () => launchURL('https://johnuberbacher.com'),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Container()));
            },
          ),
        ],
      ),
    );
  }
}

class SimpleDialogItem extends StatelessWidget {
  const SimpleDialogItem(
      {Key? key, this.icon, this.color, this.text, this.onPressed})
      : super(key: key);

  final IconData? icon;
  final Color? color;
  final String? text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 36.0, color: color),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 16.0),
            child: Text(text!),
          ),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int starCount;
  final num rating;
  final Color? color;
  final MainAxisAlignment rowAlignment;

  StarRating({
    this.starCount = 5,
    this.rating = .0,
    this.color,
    this.rowAlignment = MainAxisAlignment.center,
  });

  Widget buildStar(
      BuildContext context, int rank, MainAxisAlignment rowAlignment) {
    Icon icon;
    if (rank >= rating) {
      return icon = Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    } else if (rank > rating - 1 && rank < rating) {
      return icon = Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      return icon = Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: rowAlignment,
      children: List.generate(
        starCount,
        (rank) => buildStar(context, rank, rowAlignment),
      ),
    );
  }
}

String titleCase(String text) {
  if (text.length <= 1) return text.toUpperCase();
  var words = text.split(' ');
  var capitalized = words.map((word) {
    var first = word.substring(0, 1).toUpperCase();
    var rest = word.substring(1);
    return '$first$rest';
  });
  return capitalized.join(' ');
}

Widget myHealthTextField({String? hintText, String? initialValue}) {
  // new
  return Container(
    margin: const EdgeInsets.only(
      left: 20.0,
      right: 20.0,
      bottom: 20.0,
    ),
    child: TextFormField(
      textAlign: TextAlign.end,
      initialValue: initialValue,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),
        enabledBorder: OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
        hintText: hintText,
        prefix: Padding(
          padding: const EdgeInsets.only(
            right: 15,
          ),
          child: Text(
            hintText!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '';
        }
        return null;
      },
    ),
  );
}

Widget imageDialog(context, imageUrl) {
  return Dialog(
    child: Container(
      width: MediaQuery.of(context).size.width * 1.0,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage(imageUrl), fit: BoxFit.cover)),
    ),
  );
}

Widget customTextField(context, String hintText, IconData icon) {
  return TextField(
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFFb1b2c4),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(60),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(60),
      ),
      filled: true,
      fillColor: Colors.black.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 25.0,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF6aa6f8),
      ),
      //
    ),
    style: const TextStyle(color: Colors.white),
  );
}

Widget myHealthCoverages(String coverageName, IconData coverageIcon) {
  return FractionallySizedBox(
    widthFactor: 0.33,
    child: AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.only(
          right: 15.0,
          bottom: 15.0,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Color(0xFFe9f0f3),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                coverageIcon,
                size: 35,
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 7.5,
                ),
                child: Text(
                  coverageName,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget myHealthScore(double userHealthScore, context) {
  return Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      color: Color(0xFFe9f0f3),
    ),
    child: Center(
      child: Container()
    ),
  );
}

Widget sectionTitle(context, String title) {
  return Container(
    margin: const EdgeInsets.only(
      top: 20.0,
      left: 20.0,
      right: 20.0,
      bottom: 20.0,
    ),
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: 20,
          ),
          child: Divider(
            color: Colors.black12,
            height: 1,
            thickness: 1,
          ),
        ),
      ],
    ),
  );
}

Widget doctorCard(
    {String? firstName,
    String? lastName,
    String? prefix,
    String? specialty,
    String? imagePath,
    num? rank,
    BuildContext? context}) {
  return Container(
    margin: const EdgeInsets.only(
      left: 20.0,
      right: 20.0,
      top: 10.0,
    ),
    child: Card(
      elevation: 3.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      color: Colors.white,
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        onTap: () {
        },
        child: Align(
          alignment: FractionalOffset.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    right: 20.0,
                  ),
                  child: ClipOval(
                    child: imagePath != null
                        ? CachedNetworkImage(
                            imageUrl: imagePath,
                            imageBuilder: (context, imageProvider) =>
                                Container(
                              width: 70.0,
                              height: 72.5,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/images/user.jpg'),
                          )
                        : (Container()),
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: FractionalOffset.centerLeft,
                        child: Text(
                          '${prefix!.capitalize()} ${firstName!.capitalize()} ${lastName!.capitalize()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF6f6f6f),
                          ),
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                          ),
                          child: Text(
                            specialty!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9f9f9f),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                          ),
                          child: StarRating(
                            rating: rank!,
                            rowAlignment: MainAxisAlignment.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
