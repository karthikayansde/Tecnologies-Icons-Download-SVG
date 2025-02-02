import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:technologies_icons_download_png_svg/strings.dart';
import 'package:technologies_icons_download_png_svg/web_download.dart';

class HomeUi extends StatefulWidget {
  const HomeUi({super.key});

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  List<Map<String, dynamic>> filteredData = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredData = MyStrings.jsonData;
  }

  // Search Functionality
  void _filterData(String query) {
    setState(() {
      filteredData = MyStrings.jsonData.where((element) => element['name'].toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/app_icons/Screenshot_2024-12-17_182659-removebg-preview.svg',
                width: 65,
                height: 65,
              ),
              Text(
                MyStrings.appName,
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          ),
          SizedBox(
            width: 250,
            child: TextField(
              controller: _searchController,
              onChanged: _filterData,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyStrings.primary),
                ),
                suffixIcon: Icon(Icons.search),
                hintText: "Search items...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          filteredData.length == 0
              ? Text(
                  "We can't find that one...",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        for (int i = 0; i < filteredData.length; i++)
                          ...filteredData[i]['list'].map<Widget>((fileName) => CustomCard(
                                name: filteredData[i]['name'],
                                imageUrl: fileName,
                              )),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: BottomBar(),
                        )
                      ],
                    ),
                  ),
                ),
          if (filteredData.length == 0)
            Expanded(
              child: Align(alignment: Alignment.bottomCenter, child: BottomBar()),
            )
        ],
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  final String name;
  final String imageUrl;

  const CustomCard({Key? key, required this.name, required this.imageUrl}) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isHovered = false; // Tracks hover state

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return ImageViewDialog(
              imageUrl: widget.imageUrl,
              name: widget.name,
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
            });
          },
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 0),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(color: /*_isHovered ? Colors.blue[50] : */ MyStrings.cardWhite, borderRadius: BorderRadius.circular(5), border: Border.all(width: 2, color: _isHovered ? Colors.green : Colors.transparent)),
              child: SizedBox(
                height: 150,
                width: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/icons/${widget.name}/${widget.imageUrl}',
                        width: 70,
                        height: 70,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: _isHovered ? Colors.green : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.download,
                            size: 15,
                            color: _isHovered ? Colors.green : Colors.black,
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
      ),
    );
  }
}

class ImageViewDialog extends StatelessWidget {
  final String name;
  final String imageUrl;

  const ImageViewDialog({required this.imageUrl, Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyStrings.cardWhite,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              )),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.cancel_outlined),
              )
            ],
          ),
          SvgPicture.asset(
            'assets/icons/$name/$imageUrl',
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => Center(
                  child: CircularProgressIndicator(),
                ),
              );
              await saveAndLaunchFileWeb(await loadSvgAsBytes('assets/icons/$name/$imageUrl'), "$name.svg");
              Navigator.pop(context);
            },
            icon: const Icon(Icons.download, color: Colors.black),
            label: const Text(
              "Download SVG",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.black)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.maxFinite,
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            MyStrings.header1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            MyStrings.header2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            MyStrings.rights,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
