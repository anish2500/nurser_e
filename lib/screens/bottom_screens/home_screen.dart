import 'package:flutter/material.dart';
import 'package:nurser_e/widgets/my_button.dart';
import 'package:nurser_e/widgets/my_searchbox.dart';
import 'package:nurser_e/widgets/my_textfield.dart';
import 'package:nurser_e/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, double>> circleImagePositions = [
    {'right': 50, 'top': 30, 'size': 40},
    {'right': 20, 'top': 70, 'size': 40},
    {'right': 80, 'bottom': 50, 'size': 40},
  ];

  final List<String> imagePaths = [
    'assets/images/plant1.jpg',
    'assets/images/plant2.jpg',
    'assets/images/plant3.jpg',
  ];

  final List<Map<String, String>> indoorPlants = [
    {'title': 'Snake Plant', 'price': 'Rs800', 'category': 'Indoor'},
    {'title': 'Peace Lily', 'price': 'Rs1200', 'category': 'Indoor'},
    {'title': 'Jade Plant', 'price': 'Rs600', 'category': 'Indoor'},
    {'title': 'Calathea', 'price': 'Rs1500', 'category': 'Indoor'},
  ];

  final List<Map<String, String>> outdoorPlants = [
    {'title': 'Rose', 'price': 'Rs500', 'category': 'Outdoor'},
    {'title': 'Hibiscus', 'price': 'Rs400', 'category': 'Outdoor'},
    {'title': 'Jasmine', 'price': 'Rs600', 'category': 'Outdoor'},
    {'title': 'Poinsettia', 'price': 'Rs800', 'category': 'Outdoor'},
  ];

  final List<Map<String, String>> fruitsHerbs = [
    {'title': 'Bay Leaf', 'price': 'Rs700', 'category': 'Fruits & Herbs'},
    {'title': 'Lemon Plant', 'price': 'Rs1200', 'category': 'Fruits & Herbs'},
    {'title': 'Timur', 'price': 'Rs900', 'category': 'Fruits & Herbs'},
    {'title': 'Curry Leaf', 'price': 'Rs500', 'category': 'Fruits & Herbs'},
  ];

  final List<Map<String, String>> seasonalPlants = [
    {'title': 'Marigold', 'price': 'Rs200', 'category': 'Seasonal'},
    {'title': 'Makhamali', 'price': 'Rs600', 'category': 'Seasonal'},
    {'title': 'Gladiolus', 'price': 'Rs800', 'category': 'Seasonal'},
    {'title': 'Lotus', 'price': 'Rs1000', 'category': 'Seasonal'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: [
          
          SafeArea(
            bottom: false,
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: const Icon(Icons.dashboard, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Dashboard",
                    style: TextStyle(
                      fontFamily: 'Poppins Bold',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.green.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),

         
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 6),

                  // my_searchbox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: MyTextField(
                      fillColor: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(50),
                      
                      controller: TextEditingController(), 
                      hint: 'Search...',
                      hintStyle: TextStyle(
                        fontFamily: 'Poppins Regular', 
                        color: Colors.grey.shade600, 
                        fontSize: 16
                      ),),
                  ),

                  const SizedBox(height: 12),

                 
                  Card(
                    elevation: 1,
                    color: const Color(0xFF3DC352),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 160,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "New Arrivals",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "Explore the latest",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "plant arrived in our garden",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                const Spacer(),
                                MyButton(
                                  onPressed: () {},
                                  text: "Shop Now",
                                  width: 120,
                                  height: 40,
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    70,
                                    192,
                                    84,
                                  ),
                                  textColor: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),

                          // Circular images
                          Positioned(
                            right: circleImagePositions[0]['right'],
                            top: circleImagePositions[0]['top'],
                            child: Container(
                              width: circleImagePositions[0]['size'],
                              height: circleImagePositions[0]['size'],
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.white, width: 2),
                                image: DecorationImage(
                                  image: AssetImage(imagePaths[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: circleImagePositions[1]['right'],
                            top: circleImagePositions[1]['top'],
                            child: Container(
                              width: circleImagePositions[1]['size'],
                              height: circleImagePositions[1]['size'],
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.white, width: 2),
                                image: DecorationImage(
                                  image: AssetImage(imagePaths[1]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: circleImagePositions[2]['right'],
                            bottom: circleImagePositions[2]['bottom'],
                            child: Container(
                              width: circleImagePositions[2]['size'],
                              height: circleImagePositions[2]['size'],
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.white, width: 2),
                                image: DecorationImage(
                                  image: AssetImage(imagePaths[2]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Top Sold Section
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, bottom: 12.0),
                    child: Text(
                      "Top Sold",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final topSoldProducts = [
                          {
                            'title': 'Snake Plant',
                            'price': 'Rs800',
                            'category': 'Indoor',
                            'image': 'assets/images/snake.jpg'
                          },
                          {
                            'title': 'Rose',
                            'price': 'Rs500',
                            'category': 'Outdoor',
                            'image': 'assets/images/rose.jpg'
                          },
                          {
                            'title': 'Bay Leaf',
                            'price': 'Rs700',
                            'category': 'Fruits & Herbs',
                            'image': 'assets/images/bayleaf.jpg'
                          },
                          {
                            'title': 'Marigold',
                            'price': 'Rs200',
                            'category': 'Seasonal',
                            'image': 'assets/images/marigold.jpg'
                          },
                        ];
                        return ProductCard(
                          title: topSoldProducts[index]['title']!,
                          price: topSoldProducts[index]['price']!,
                          categories: topSoldProducts[index]['category']!,
                          imagePath: topSoldProducts[index]['image']!,
                          onTap: () {},
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // Recent Arrivals Section
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, bottom: 12.0),
                    child: Text(
                      "Recent Arrivals",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final recentArrivalsProducts = [
                          {
                            'title': 'Peace Lily',
                            'price': 'Rs1200',
                            'category': 'Indoor',
                            'image': 'assets/images/peacelily.jpg'
                          },
                          {
                            'title': 'Jasmine',
                            'price': 'Rs600',
                            'category': 'Outdoor',
                            'image': 'assets/images/jasmine.jpg'
                          },
                          {
                            'title': 'Lemon Plant',
                            'price': 'Rs1200',
                            'category': 'Fruits & Herbs',
                            'image': 'assets/images/lemon.jpg'
                          },
                          {
                            'title': 'Lotus',
                            'price': 'Rs1000',
                            'category': 'Seasonal',
                            'image': 'assets/images/lily.jpg'
                          },
                        ];
                        return ProductCard(
                          title: recentArrivalsProducts[index]['title']!,
                          price: recentArrivalsProducts[index]['price']!,
                          categories: recentArrivalsProducts[index]['category']!,
                          imagePath: recentArrivalsProducts[index]['image']!,
                          onTap: () {},
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
