import '../models/category.dart';
import '../sources/demo_categories.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAll();
  Category? byId(String id);
}

class DemoCategoryRepository implements CategoryRepository {
  @override
  Future<List<Category>> getAll() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return DemoCategories.all;
  }

  @override
  Category? byId(String id) => DemoCategories.byId(id);
}
