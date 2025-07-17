import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../viewmodels/home_cubit.dart';
import '../viewmodels/home_state.dart';
import '../../shared/views/webview_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/search-bar-background.jpg',
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.earbuds,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Big Ear',
                                    style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1.5, 1.5),
                                          blurRadius: 2.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Hi, Guest',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 2.0,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 250,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    width: 64,
                                    height: 64,
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
                                    width: 64,
                                    height: 64,
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
                                    width: 64,
                                    height: 64,
                                  ),
                                ),
                                Image.asset(
                                  'assets/icons/blibli.png',
                                  width: 64,
                                  height: 64,
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
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
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'assets/icons/instagram.png',
                                  width: 50,
                                  height: 50,
                                ),
                                Image.asset(
                                  'assets/icons/tik-tok.png',
                                  width: 50,
                                  height: 50,
                                ),
                                Image.asset(
                                  'assets/icons/whatsapp.png',
                                  width: 50,
                                  height: 50,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is HomeError) {
              return Center(child: Text("Error: \${state.error}"));
            }
            return const Center(child: Text("Initializing..."));
          },
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
