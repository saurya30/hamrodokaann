import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/products/product_cards/product_card_horizontal.dart';
import '../../../../common/widgets/shimmers/horizontal_product_shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../data/repositories/product/product_repository.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/cloud_helper_functions.dart';
import '../../controllers/categories_controller.dart';
import '../../models/category_model.dart';
import '../all_products/all_products.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(category.name),
        showActions: false,
        showSkipButton: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Banner
              // const TRoundedImage(width: double.infinity, imageUrl: TImages.promoBanner3, applyImageRadius: true),
              // const SizedBox(height: TSizes.spaceBtwSections),

              /// Sub Categories
              FutureBuilder(
                future: controller.getSubCategories(category.id),
                builder: (_, snapshot) {
                  /// Handle Loader, No Record, OR Error Message
                  const loader = THorizontalProductShimmer();
                  final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
                  if (widget != null) return widget;

                  /// Record found.
                  final subCategories = snapshot.data ?? [];
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: subCategories.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final subCategory = subCategories[index];

// Step 1: Check if id is empty or null
                      if (subCategory.id.isEmpty) {
                        print("Skipping sub-category with empty ID: ${subCategory.name}");
                        return const Text("Invalid sub-category.");
                      }

// Continue if it's safe
                      return FutureBuilder(
                        future: controller.getCategoryProducts(categoryId: subCategory.id),
                        builder: (_, snapshot) {
                          /// Handle Loader, No Record, OR Error Message
                          final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
                          if (widget != null) return widget;

                          /// Congratulations 🎊 Record found.
                          final products = snapshot.data ?? [];
                          if (products.isEmpty) return Text("No products found.");

                          return Column(
                            children: [
                              /// Sub Category Heading
                              TSectionHeading(
                                title: subCategory.name,
                                showActionButton: true,
                                onPressed: () => Get.to(() => AllProducts(
                                      title: subCategory.name,
                                      futureMethod: ProductRepository.instance.getProductsForCategory(subCategory.id, 1),
                                    )),
                              ),
                              const SizedBox(height: TSizes.spaceBtwItems / 2),

                              /// Sub Category Products
                              SizedBox(
                                height: 120,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: products.length,
                                  separatorBuilder: (context, index) => const SizedBox(width: TSizes.spaceBtwItems),
                                  itemBuilder: (context, index) => TProductCardHorizontal(product: products[index]),
                                ),
                              ),
                              const SizedBox(height: TSizes.spaceBtwSections),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
