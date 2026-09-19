import '../models/address.dart';
import '../models/user_profile.dart';
import '../sources/local_storage.dart';

abstract class UserRepository {
  UserProfile? getProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<void> logout();
  List<Address> getAddresses();
  Future<void> saveAddresses(List<Address> list);
}

class LocalUserRepository implements UserRepository {
  LocalUserRepository(this._storage);
  final LocalStorage _storage;

  static const demoProfile = UserProfile(
    name: 'Mehmon foydalanuvchi',
    phone: '+998901234567',
    email: 'mehmon@bozorgo.uz',
  );

  static const demoAddresses = [
    Address(
      id: 'a1',
      title: 'Uy',
      city: 'Toshkent',
      street: 'Amir Temur shoh ko\'chasi, 15',
      details: '3-podyezd, 5-qavat, 42-xonadon',
      isDefault: true,
    ),
    Address(
      id: 'a2',
      title: 'Ish',
      city: 'Toshkent',
      street: 'Mustaqillik shoh ko\'chasi, 88',
      details: 'IT Park, 4-qavat',
    ),
  ];

  @override
  UserProfile? getProfile() {
    final raw = _storage.readProfile();
    if (raw == null) return demoProfile;
    return UserProfile.fromJson(raw);
  }

  @override
  Future<void> saveProfile(UserProfile profile) => _storage.writeProfile(profile.toJson());

  @override
  Future<void> logout() => _storage.clearProfile();

  @override
  List<Address> getAddresses() {
    final raw = _storage.readAddresses();
    if (raw == null) return demoAddresses;
    return raw.map(Address.fromJson).toList();
  }

  @override
  Future<void> saveAddresses(List<Address> list) =>
      _storage.writeAddresses(list.map((a) => a.toJson()).toList());
}
