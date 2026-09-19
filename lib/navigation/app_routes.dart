/// Marshrut nomlari va yo'llari — bir joyda.
class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const categories = '/categories';
  static const cart = '/cart';
  static const orders = '/orders';
  static const profile = '/profile';

  static const search = '/search';
  static const product = '/product/:id';
  static const category = '/category/:id';
  static const checkout = '/checkout';
  static const orderSuccess = '/order-success/:id';
  static const orderDetail = '/orders/:id';
  static const wishlist = '/wishlist';
  static const addresses = '/addresses';
  static const editProfile = '/profile/edit';
  static const settings = '/settings';
  static const notifications = '/notifications';
  static const help = '/help';
  static const about = '/about';
  static const collection = '/collection/:tag';

  static String productPath(String id) => '/product/$id';
  static String categoryPath(String id) => '/category/$id';
  static String orderDetailPath(String id) => '/orders/$id';
  static String orderSuccessPath(String id) => '/order-success/$id';
  static String collectionPath(String tag) => '/collection/$tag';
  static String searchPath({String? q}) =>
      q == null || q.isEmpty ? search : '$search?q=${Uri.encodeQueryComponent(q)}';
}
