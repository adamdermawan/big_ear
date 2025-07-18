import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:big_ear/core/network/mock_up_api.dart';
import '../viewmodels/items_cubit.dart';
import '../viewmodels/items_state.dart';
import 'items_detail_view.dart';

class ItemsView extends StatefulWidget {
  const ItemsView({super.key});

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ItemsCubit>().loadItems();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = springBed
        .where(
          (item) => item['name'].toString().toLowerCase().contains(
            searchQuery.toLowerCase(),
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Produk Kami")),
      body: Column(
        children: [
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
                                  builder: (context) =>
                                      ItemsDetailView(item: item),
                                ),
                              );
                            },
                            leading: Image.asset(
                              item['imageAsset'],
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RatingBarIndicator(
                                  rating: item['rate']?.toDouble() ?? 0.0,
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
                                  item['desc'],
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
                  return Center(child: Text(state.error));
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
