import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/models/review_model.dart';
import 'package:techtac_electro/models/user_model.dart';
import 'package:techtac_electro/provider/cart_provider.dart';
import 'package:techtac_electro/provider/dark_theme_provider.dart';
import 'package:techtac_electro/provider/product_provider.dart';
import 'package:techtac_electro/widgets/app_name_text.dart';
import 'package:techtac_electro/widgets/products/heart_btn.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import 'package:techtac_electro/widgets/text_widget.dart';
import 'package:intl/intl.dart';

import '../../provider/user_provider.dart';
import '../../services/my_app_method.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _reviewController = TextEditingController();
  double _rating = 5.0;
  bool _hasSubmittedReview = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.getUserModel;
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrProduct = productProvider.findByProdId(productId);

    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const AppNameTextWidget(fontSize: 20),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.canPop(context) ? Navigator.pop(context) : null;
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
        ),
      ),
      body: getCurrProduct == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
        child: Column(
          children: [
            FancyShimmerImage(
              imageUrl: getCurrProduct.productImage,
              height: size.height * 0.38,
              width: double.infinity,
              boxFit: BoxFit.contain,
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          getCurrProduct.productTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      SubtitleTextWidget(
                        label: "${getCurrProduct.productPrice}\$",
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HeartButtonWidget(
                          productId: getCurrProduct.productId,
                          color: Colors.blue.shade300,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: kBottomNavigationBarHeight - 10,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final user = await userProvider.fetchUserInfo();

                                if (user == null) {
                                  // Display a message or navigate to the login screen
                                  MyAppMethods.showErrorORWarningDialog(
                                    context: context,
                                    subtitle: 'Please log in to add items to the cart.',
                                    fct: () {},
                                  );
                                  return;
                                }

                                if (cartProvider.isProductInCart(productId: getCurrProduct.productId)) {
                                  return;
                                }

                                try {
                                  await cartProvider.addToCartFirebase(
                                    productId: getCurrProduct.productId,
                                    qty: 1,
                                    context: context,
                                  );
                                } catch (error) {
                                  MyAppMethods.showErrorORWarningDialog(
                                    context: context,
                                    subtitle: error.toString(),
                                    fct: () {},
                                  );
                                }
                                cartProvider.addProductToCart(productId: getCurrProduct.productId);
                              },
                              icon: Icon(
                                cartProvider.isProductInCart(productId: getCurrProduct.productId)
                                    ? Icons.check
                                    : Icons.add_shopping_cart_rounded,
                              ),
                              label: Text(
                                cartProvider.isProductInCart(productId: getCurrProduct.productId)
                                    ? "In cart"
                                    : "Add to cart",
                                style: TextStyle(
                                  color: themeProvider.getIsDarkTheme ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitlesTextWidget(label: "About this item"),
                      SubtitleTextWidget(label: "In ${getCurrProduct.productCategory}"),
                    ],
                  ),
                  const SizedBox(height: 25),
                  SubtitleTextWidget(label: getCurrProduct.productDescription),
                  const SizedBox(height: 25),
                  const Divider(),
                  const TitlesTextWidget(label: "Reviews"),
                  const Divider(),
                  const SizedBox(height: 15),
                  _buildReviewForm(context, productId, user, themeProvider),
                  _buildReviewsList(context, productId, user),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewForm(BuildContext context, String productId, UserModel? user, ThemeProvider themeProvider) {
    if (user == null) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Please login to leave a review"),
      );
    }

    return StreamBuilder<List<ReviewModel>>(
      stream: Provider.of<ProductProvider>(context).fetchUserReview(productId, user.userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userReviews = snapshot.data!;
          if (userReviews.isNotEmpty) {
            final review = userReviews.first;
            _reviewController.text = review.reviewText;
            _rating = review.rating;
            _hasSubmittedReview = true;
          } else {
            _hasSubmittedReview = false;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_hasSubmittedReview) ...[
              TextField(
                controller: _reviewController,
                decoration: const InputDecoration(labelText: 'Enter your review'),
                maxLines: 3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0), // Apply padding to the Row
                child: Row(
                  children: [
                    const Text('Rating:'),
                    Expanded(
                      child: Slider(
                        value: _rating,
                        onChanged: (newRating) {
                          setState(() {
                            _rating = newRating;
                          });
                        },
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: _rating.toString(),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (_reviewController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter a review."),
                            ),
                          );
                          return;
                        }
                        final newReview = ReviewModel(
                          productId: productId,
                          userId: user.userId,
                          username: user.userName,
                          userProfileImage: user.userImage,
                          reviewText: _reviewController.text,
                          rating: _rating,
                          createdAt: Timestamp.now(),
                        );
                        Provider.of<ProductProvider>(context, listen: false).addReview(productId, newReview);
                        _reviewController.clear();
                        setState(() {
                          _rating = 5.0;
                          _hasSubmittedReview = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Review submitted successfully."),
                          ),
                        );
                      },
                      child: Text(
                        'Submit Review',
                        style: TextStyle(
                          color: themeProvider.getIsDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildReviewsList(BuildContext context, String productId, UserModel? user) {
    return StreamBuilder<List<ReviewModel>>(
      stream: Provider.of<ProductProvider>(context).fetchReviews(productId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final reviews = snapshot.data!;
        if (reviews.isEmpty) {
          return const Text('No reviews yet. Be the first to review!');
        }

        // Separate current user's review
        ReviewModel? currentUserReview;
        final otherReviews = <ReviewModel>[];

        for (var review in reviews) {
          if (user != null && review.userId == user.userId) {
            currentUserReview = review;
          } else {
            otherReviews.add(review);
          }
        }

        // Combine current user's review at the top
        final sortedReviews = [
          if (currentUserReview != null) currentUserReview,
          ...otherReviews,
        ];

        return Column(
          children: sortedReviews.map((review) => ReviewCard(review: review)).toList(),
        );
      },
    );
  }
}

class ReviewCard extends StatefulWidget {
  final ReviewModel review;
  const ReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  late TextEditingController _editReviewController;
  late double _editRating;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _editReviewController = TextEditingController(text: widget.review.reviewText);
    _editRating = widget.review.rating;
  }

  @override
  void dispose() {
    _editReviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.getUserModel;
    final review = widget.review;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Same padding as the review input field
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(review.userProfileImage),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubtitleTextWidget(
                      label: review.username,
                    ),
                    Text(
                      DateFormat('yy:MM:dd HH:mm').format(review.createdAt.toDate()),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (user != null && user.userId == review.userId)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Provider.of<ProductProvider>(context, listen: false)
                              .deleteReview(review.productId, review.reviewId!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Review deleted successfully."),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),
            isEditing
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _editReviewController,
                  decoration: const InputDecoration(labelText: 'Edit your review'),
                  maxLines: 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Apply padding to the Row
                  child: Row(
                    children: [
                      const SubtitleTextWidget(label: 'Rating:'),
                      Expanded(
                        child: Slider(
                          value: _editRating,
                          onChanged: (newRating) {
                            setState(() {
                              _editRating = newRating;
                            });
                          },
                          min: 1,
                          max: 5,
                          divisions: 4,
                          label: _editRating.toString(),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_editReviewController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter a review."),
                              ),
                            );
                            return;
                          }

                          final updatedReview = ReviewModel(
                            reviewId: review.reviewId,
                            productId: review.productId,
                            userId: review.userId,
                            username: review.username,
                            userProfileImage: review.userProfileImage,
                            reviewText: _editReviewController.text,
                            rating: _editRating,
                            createdAt: review.createdAt,
                          );

                          try {
                            await Provider.of<ProductProvider>(context, listen: false)
                                .updateReview(review.productId, updatedReview);
                            setState(() {
                              isEditing = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Review updated successfully."),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to update review."),
                              ),
                            );
                          }
                        },
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                ),
              ],
            )
                : SubtitleTextWidget(
              label:  review.reviewText,
            ),
            const SizedBox(height: 10),
            _buildStarRating(review.rating),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(
            Icons.star,
            color: Colors.lightBlue,
            size: 20,
          );
        } else if (index == fullStars && halfStar) {
          return const Icon(
            Icons.star_half,
            color: Colors.lightBlue,
            size: 20,
          );
        } else {
          return const Icon(
            Icons.star_border,
            color: Colors.lightBlue,
            size: 20,
          );
        }
      }),
    );
  }
}
