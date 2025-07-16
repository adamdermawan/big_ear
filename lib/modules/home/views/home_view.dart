import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../viewmodels/home_cubit.dart';
import '../viewmodels/home_state.dart';
import 'webview_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<String> imgList = [
    'assets/images/image-1.jpg',
    'assets/images/image-2.jpg',
    'assets/images/image-3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Big Ear",
          style: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WebViewScreen(
                                  url:
                                      'https://www.tokopedia.com/elephantbed?entrance_name=search_suggestion_store&source=universe&st=product',
                                ),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/icons/tokopedia.png',
                            width: 12,
                            height: 12,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WebViewScreen(
                                  url:
                                      'https://shopee.co.id/elephantofficial?entryPoint=ShopBySearch&searchKeyword=elephant%20spring%20bed',
                                ),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/icons/shopee.png',
                            width: 12,
                            height: 12,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WebViewScreen(
                                  url:
                                      'https://www.lazada.co.id/tag/elephant-springbed/?spm=a2o4j.tm80363353.search.d_go&q=elephant%20springbed&catalog_redirect_tag=true',
                                ),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/icons/lazada.png',
                            width: 12,
                            height: 12,
                          ),
                        ),

                        Image.asset(
                          'assets/icons/akulaku.png',
                          width: 12,
                          height: 12,
                        ),
                        Image.asset(
                          'assets/icons/blibli.png',
                          width: 12,
                          height: 12,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                      ),
                      items: imgList
                          .map(
                            (item) => Center(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                child: Image.asset(
                                  item,
                                  fit: BoxFit.cover,
                                  width: 1000,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              );
            } else if (state is HomeError) {
              return Center(child: Text("Error: ${state.error}"));
            }
            return const Center(child: Text("Initializing..."));
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'AI Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Review'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Items',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
        ],
      ),
    );
  }
}
