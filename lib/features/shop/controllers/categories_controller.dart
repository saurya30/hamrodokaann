import 'package:get/get.dart';

import '../../../data/repositories/categories/category_repository.dart';
import '../../../data/repositories/product/product_repository.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/popups/loaders.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  RxBool isLoading = true.obs;
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
  final _categoryRepository = Get.put(CategoryRepository());

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  /// -- Load category data
  Future<void> fetchCategories() async {
    try {
      // Show loader while loading categories
      isLoading.value = true;

      // Fetch categories from data source (Firestore, API, etc.)
      final fetchedCategories = await _categoryRepository.fetchAllItems();

      fetchedCategories.sort((a, b) {
        if (a.priority == b.priority) {
          return a.id.compareTo(b.id); // If priorities are the same, compare by id or any other field
        }
        return a.priority.compareTo(b.priority); // Sort by priority
      });

      // Update the categories list
      allCategories.assignAll(fetchedCategories);

      // Filter featured categories
      featuredCategories
          .assignAll(allCategories.where((category) => (category.isFeatured) && category.parentId.isEmpty).take(8).toList());
    } catch (e) {
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// -- Load selected category data
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    // Fetch all categories where ParentId = categoryId;
    try {
      final subCategories = await _categoryRepository.getSubCategories(categoryId);
      return subCategories;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /// Get Category or Sub-Category Products.
  /// If you want to fetch all the products in this category SET [limit] to -1
  Future<List<ProductModel>> getCategoryProducts({required String categoryId, int limit = -1}) async {
    // Fetch limited (4) products against each subCategory;
    final products = await ProductRepository.instance.getProductsForCategory(categoryId, limit);
    return products;
  }

  Future<void> updateCategoryView(String categoryId, CategoryModel category) async {
    int view = category.viewCount;
    view++;
    _categoryRepository.updateSingleField(categoryId, {"viewCount": view});
  }
}
