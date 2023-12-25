//home_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:bfcai_movies/data/apis.dart';
// import 'package:bfcai/screens/movies.dart';
// import 'package:bfcai/screens/tvseries.dart';
// import 'package:bfcai/screens/upcoming.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Map<String, dynamic>> trendinglist = [];

  Future<void> trendingshows() async {
    try {
      if (choiceurl == 1) {
        final trendingresponse = await http.get(Uri.parse(trendingweekurl));
        if (trendingresponse.statusCode == 200) {
          var trenddecode = jsonDecode(trendingresponse.body);
          var trendingwjson = trenddecode['results'];
          for (var i = 0; i < trendingwjson.length; i++) {
            trendinglist.add({
              'id': trendingwjson[i]['id'],
              'poster_path': trendingwjson[i]['poster_path'],
              'vote_average': trendingwjson[i]['vote_average'],
              'media_type': trendingwjson[i]['media_type'],
              'indexno': i,
            });
          }
        }
      } else if (choiceurl == 2) {
        final trendingdayresponse = await http.get(Uri.parse(trendingdayurl));
        if (trendingdayresponse.statusCode == 200) {
          var trenddecode = jsonDecode(trendingdayresponse.body);
          var trendingwjson = trenddecode['results'];
          for (var i = 0; i < trendingwjson.length; i++) {
            trendinglist.add({
              'id': trendingwjson[i]['id'],
              'poster_path': trendingwjson[i]['poster_path'],
              'vote_average': trendingwjson[i]['vote_average'],
              'media_type': trendingwjson[i]['media_type'],
              'indexno': i,
            });
          }
        }
      }
    } catch (e) {
      print("Error : $e".toString());
    }
  }

  int choiceurl = 1;
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: const Text('BFCAI Movie'),
      //   centerTitle: true,
      // ),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          centerTitle: true,
          toolbarHeight: 60,
          pinned: true,
          expandedHeight: MediaQuery.of(context).size.height * 0.5,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: FutureBuilder(
              future: trendingshows(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CarouselSlider(
                    //* This is for the Curve Effect
                    options: CarouselOptions(
                      height: 330,
                      autoPlay: true,
                      viewportFraction: 0.55,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: const Duration(seconds: 1),
                      enlargeCenterPage: true,
                      pageSnapping: true,

                      // viewportFraction: 1,
                      // autoPlay: true,
                      // autoPlayInterval: const Duration(seconds: 2),
                      // height: MediaQuery.of(context).size.height,
                      // pageSnapping: true,
                    ),
                    items: trendinglist.map((e) {
                      return Builder(builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {},
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.of(context).push()
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: SizedBox(
                                height: 300,
                                width: 210,
                                child: Image.network(
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.cover,
                                  'https://image.tmdb.org/t/p/w500${e['poster_path']}',
                                ),
                              ),
                            ),
                          ),

                          //! For making the effect up
                          // child: Container(
                          //   width: MediaQuery.of(context).size.width,
                          //   decoration: BoxDecoration(
                          //     image: DecorationImage(
                          //       colorFilter: ColorFilter.mode(
                          //         Colors.black.withOpacity(0.3),
                          //         BlendMode.darken,
                          //       ),
                          //       image: NetworkImage(
                          //           'https://image.tmdb.org/t/p/w500${e['poster_path']}'),
                          //       fit: BoxFit.fill,
                          //       filterQuality: FilterQuality.high,
                          //     ),
                          //   ),
                          // ),
                        );
                      });
                    }).toList(),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue[800],
                    ),
                  );
                }
              },
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Trending',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    //fontFamily: 'Caveat',
                  )),
              const SizedBox(width: 10),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButton(
                    // dropdownColor: Colors.tealAccent,
                    onChanged: (value) {
                      setState(() {
                        trendinglist.clear();
                        choiceurl = int.parse(value.toString());
                      });
                    },
                    autofocus: true,
                    underline: Container(
                      height: 0,
                      color: Colors.transparent,
                    ),
                    dropdownColor: Colors.black.withOpacity(0.2),
                    icon: Icon(
                      Icons.arrow_drop_down_sharp,
                      color: Colors.blue[800],
                      size: 35,
                    ),
                    value: choiceurl,
                    items: [
                      DropdownMenuItem(
                        value: 1,
                        child: Text(
                          'Weekly',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 20,
                              fontFamily: 'Caveat'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text(
                          'Daily',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Caveat'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const Center(
              child: Text('sample text'),
            ),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: TabBar(
                physics: const BouncingScrollPhysics(),
                labelPadding: const EdgeInsets.symmetric(horizontal: 25),
                isScrollable: true,
                controller: tabController,
                indicator: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue.withOpacity(0.4),
                ),
                tabs: const [
                  Tab(child: Text('  Tv Series  ')),
                  Tab(child: Text('   Movies    ')),
                  Tab(child: Text('   Upcoming  ')),
                ],
              ),
            ),
            SizedBox(
              height: 1050,
              child: TabBarView(
                controller: tabController,
                children: const [
                  // TvSeries(),
                  // Movies(),
                  // Upcomming(),
                ],
              ),
            )
            // SizedBox(
            //   height: 1050,
            //   child: TabBarView(
            //     controller: tabController,
            //     children: const [
            //       TvSeries(),
            //       Movies(),
            //       Upcomming(),
            //     ],
            //   ),
            // )
          ]),
        ),
      ]),
    );
  }
}

// ! try to modify the Trending text and weekly dropDownMenue
// * to be in more suitable place



// Singlechildscrollview
//listview
//listview.builder
//gridview
//gridview.builder
//customscrollview
