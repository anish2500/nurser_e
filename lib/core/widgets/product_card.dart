import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String categories;
  final String? imagePath;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final bool isNetworkImage;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.categories,
    this.imagePath,
    this.width = 170,
    this.height = 190,
    this.onTap,
    this.isNetworkImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: 12.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    color: Colors.grey[300],
                  ),
                  child: imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: isNetworkImage
                              ? Image.network(
                                  imagePath!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.grey[600],
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                )
                              : Image.asset(
                                  imagePath!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.grey[600],
                                    );
                                  },
                                ),
                        )
                      : Icon(Icons.image, size: 40, color: Colors.grey[600]),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          categories,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        price,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
