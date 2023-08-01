import 'package:flutter/material.dart';
import 'package:show_list_beautify/themes/theme.dart';
import 'package:show_list_beautify/web_handling/showAPIHandler.dart';

import '../structs/show_data_struct.dart';
import '../widgets/show_more_text.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.showNameID, required this.isMovie}) : super(key: key);

  final int showNameID;
  final bool isMovie;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final PageController _pageController = PageController();
  late Future<ShowData> _showDataFuture;
  late ShowData _showData;

  List<Widget> pictures = [];
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _showDataFuture = fetchDataByID(widget.showNameID, widget.isMovie);

    // Add a listener to update the currentPage when the page changes
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      body: SafeArea(
        child: FutureBuilder<ShowData>(
          future: _showDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              _showData = snapshot.data!;
              pictures = _showData.pictureUrls.isEmpty
                  ? [Image.network(errURL, fit: BoxFit.fitHeight)]
                  : [
                      Image.network(_showData.pictureUrls[0],
                          fit: BoxFit.fitHeight)
                    ];
              if (_showData.pictureUrls.length > 1) {
                List<Widget> newPictures = _showData.pictureUrls
                    .skip(1) // Skip the first image URL
                    .map((url) => Image.network(url, fit: BoxFit.cover))
                    .toList();
                pictures.addAll(newPictures);
              }
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: primaryBackground,
                    leading: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        )),
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            itemCount: pictures.length,
                            itemBuilder: (context, index) {
                              return pictures[index];
                            },
                          ),
                          // picture before arrow
                          Positioned(
                            left: 8,
                            bottom: 8,
                            child: GestureDetector(
                              onTap: () {
                                if (currentPage > 0) {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                }
                              },
                              child: Visibility(
                                visible: currentPage > 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // picture after arrow
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                if (currentPage < pictures.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                }
                              },
                              // icon with background
                              child: Visibility(
                                visible: currentPage < pictures.length - 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _showData.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        color: redPrimary,
                                        size: 24 %
                                            MediaQuery.of(context).size.width,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _showData.rating.toString(),
                                        style: TextStyle(
                                          color: redPrimary,
                                          fontSize: 14 %
                                              MediaQuery.of(context).size.width,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${_showData.ratingCount} votes",
                                    style: TextStyle(
                                      color: redSecondary,
                                      fontSize: 10 %
                                          MediaQuery.of(context).size.width,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                child: Icon(
                                  Icons.navigate_next_rounded,
                                  color: redPrimary,
                                  size: 24 % MediaQuery.of(context).size.width,
                                ),
                              ),
                              Text(
                                _showData.releaseYear.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      16 % MediaQuery.of(context).size.width,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Genre: ${_showData.genres.join(', ')}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: ShowMoreText(
                            text: _showData.description,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
