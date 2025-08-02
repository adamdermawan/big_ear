import 'package:big_ear/modules/items/views/items_view.dart';
import 'package:big_ear/modules/user/viewmodels/user_cubit.dart';
import 'package:big_ear/modules/user/viewmodels/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../viewmodels/home_cubit.dart';
import '../viewmodels/home_state.dart';


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
    'assets/images/image-4.jpg',
    'assets/images/image-5.jpg',
  ];

  final TextEditingController _searchController = TextEditingController();

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
                      'assets/images/search-bar-background.png',
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
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(Icons.bed, color: Colors.black),
                              SizedBox(width: 4),
                              Text(
                                'B I G   E A R',
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
                            ],
                          ),
                        ),
                           Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: BlocBuilder<UserCubit, UserState>(
                                builder: (context, userState) {
                                  String name = 'Guest';
                                  if (userState is UserAuthenticated) {
                                    name = userState.user.name; // Assuming user.name exists
                                  }
                                  return Text(
                                    'Hi, ${name.split(' ')[0]}',
                                    style: const TextStyle(
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
                                  );
                                },
                              ),
                            ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ItemsView(searchQuery: value),
                                  ),
                                );
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: const Icon(Icons.search,
                                  color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
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
                                _buildStoreButton(
                                  'assets/icons/tokopedia-svgrepo-com.png',
                                  'Tokopedia',
                                  () async {
                                    final uri = Uri.parse(
                                        'tokopedia://store/elephantbed');
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                    } else {
                                      final fallback = Uri.parse(
                                          'https://www.tokopedia.com/elephantbed');
                                      await launchUrl(fallback,
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                                ),
                                _buildStoreButton(
                                  'assets/icons/shopee-svgrepo-com.png',
                                  'Shopee',
                                  () async {
                                    final uri = Uri.parse(
                                        'https://shopee.co.id/elephantofficial');
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  },
                                ),
                                _buildStoreButton(
                                  'assets/icons/lazada-svgrepo-com.png',
                                  'Lazada',
                                  () async {
                                    final uri = Uri.parse(
                                        'https://www.lazada.co.id/tag/elephant-springbed/');
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  },
                                ),
                                _buildStoreButton(
                                  'assets/icons/blibli-svgrepo-com.png',
                                  'Blibli',
                                  () async {
                                    final uri = Uri.parse(
                                        'https://www.blibli.com/search?s=elephant%20springbed');
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  },
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                _buildSocialButton(
                                  'assets/icons/instagram-svgrepo-com.png',
                                  'Instagram',
                                  'https://www.instagram.com/elephantbed',
                                ),
                                _buildSocialButton(
                                  'assets/icons/tiktok-svgrepo-com.png',
                                  'TikTok',
                                  'https://www.tiktok.com/@elephantmarketing',
                                ),
                                _buildMessageButton(
                                  'assets/icons/whatsapp-svgrepo-com.png',
                                  'WhatsApp',
                                  'https://wa.me/6285133130778?text=',
                                  'Saya ingin membeli springbed dari Elephant',
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
              return Center(child: Text("Error: ${state.error}"));
            }
            return const Center(child: Text("Initializing..."));
          },
        ),
      ),
    );
  }

  Widget _buildStoreButton(String imagePath, String label, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(imagePath, width: 64, height: 64),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String icon, String label, String url) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon, width: 50, height: 50),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  // This method is used to build the message button for WhatsApp
   Widget _buildMessageButton(String icon, String label, String url, String message) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url + message);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon, width: 50, height: 50),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
