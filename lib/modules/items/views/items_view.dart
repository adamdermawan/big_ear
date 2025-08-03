import 'package:big_ear/modules/shared/constants/url_path.dart';
import 'package:big_ear/modules/shared/view/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//import 'package:big_ear/core/network/mock_up_api.dart'; // No longer directly use springBed list here
import '../models/spring_bed_item.dart'; // Import SpringBedItem
import '../viewmodels/items_cubit.dart';
import '../viewmodels/items_state.dart';
import 'items_detail_view.dart';

class ItemsView extends StatefulWidget {
  final String? searchQuery;

  const ItemsView({super.key, this.searchQuery});

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  String searchQuery = '';
  List<SpringBedItem> _allItems = []; // Store all items
  String? _selectedFilter; // null, 'highest', 'lowest'

  @override
  void initState() {
    super.initState();
    // Listen for state changes to update _allItems
    context.read<ItemsCubit>().stream.listen((state) {
      if (state is ItemsLoaded) {
        setState(() {
          _allItems = state.items;
        });
      }
    });
    context.read<ItemsCubit>().loadItems();
  }

  List<SpringBedItem> _getFilteredAndSortedItems() {
    // First filter by search query
    List<SpringBedItem> filteredItems = _allItems
        .where(
          (item) => item.name.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    // Then sort by rating based on selected filter
    if (_selectedFilter == 'highest') {
      filteredItems.sort((a, b) => b.rate.compareTo(a.rate));
    } else if (_selectedFilter == 'lowest') {
      filteredItems.sort((a, b) => a.rate.compareTo(b.rate));
    }
    // If _selectedFilter is null, keep original order

    return filteredItems;
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _getFilteredAndSortedItems();

    return Scaffold(
      appBar: AppBar(title: const Text("Produk Kami")),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          
          // Rating Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Text(
                  'Urutkan: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              SizedBox(width: 4),
                              Text('Tertinggi'),
                            ],
                          ),
                          selected: _selectedFilter == 'highest',
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = selected ? 'highest' : null;
                            });
                          },
                          selectedColor: Colors.amber.withOpacity(0.3),
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star_border, size: 16),
                              SizedBox(width: 4),
                              Text('Terendah'),
                            ],
                          ),
                          selected: _selectedFilter == 'lowest',
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = selected ? 'lowest' : null;
                            });
                          },
                          selectedColor: Colors.grey.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Items List
          Expanded(
            child: BlocBuilder<ItemsCubit, ItemsState>(
              builder: (context, state) {
                if (state is ItemsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ItemsLoaded) {
                  if (filteredItems.isEmpty) {
                    return const Center(child: Text('Produk tidak ditemukan'));
                  }

                  return ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemsDetailView(
                                    item: item,
                                  ), // Pass the SpringBedItem object
                                ),
                              );
                            },
                            leading: Image.network(
                              '${ApiConstants.url}${item.imageAsset}',
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RatingBarIndicator(
                                  rating: item.rate, // Use item.rate directly
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 18.0,
                                  direction: Axis.horizontal,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.desc,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                  
                } else if (state is ItemsError) {
                  return ErrorView(
                    message: state.error,
                    onRetry: () {
                      context.read<ItemsCubit>().loadItems(); // retry logic
                    },
                  );
                }
                return const Center(child: Text('Memuat...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}