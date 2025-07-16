import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart'; // ✅ 1. Import the package
import '../viewmodels/home_cubit.dart';
import '../viewmodels/home_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  // ✅ 2. Define your image list for the carousel
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
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
            color: Colors.black, // Example: Change text color
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
                // ✅ 3. Change Column to ListView to make the page scrollable
                child: ListView(
                  children: [
                    const SizedBox(height: 16), // Add some top padding
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
                    // ✅ 4. Modify GridView
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap:
                          true, // Important to make it work inside a ListView
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                      children: [
                        Image.asset(
                          'assets/icons/tokopedia.png',
                          width: 22,
                          height: 22,
                        ),
                        Icon(Icons.shopping_cart, size: 40),
                        Icon(Icons.favorite, size: 40),
                        Icon(Icons.account_balance_wallet, size: 40),
                      ],
                    ),
                    const SizedBox(height: 24), // Space before the carousel
                    // ✅ 5. Add the CarouselSlider widget
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
                                child: Image.network(
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
