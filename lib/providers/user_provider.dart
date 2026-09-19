import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/models.dart';
import '../data/repositories/user_repository.dart';
import 'repository_providers.dart';

class UserNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    return ref.watch(userRepositoryProvider).getProfile() ?? LocalUserRepository.demoProfile;
  }

  Future<void> update({String? name, String? phone, String? email}) async {
    state = state.copyWith(name: name, phone: phone, email: email);
    await ref.read(userRepositoryProvider).saveProfile(state);
  }

  Future<void> logout() async {
    await ref.read(userRepositoryProvider).logout();
    state = LocalUserRepository.demoProfile;
  }
}

final userProvider = NotifierProvider<UserNotifier, UserProfile>(UserNotifier.new);

class AddressesNotifier extends Notifier<List<Address>> {
  @override
  List<Address> build() => ref.watch(userRepositoryProvider).getAddresses();

  Address? get defaultAddress =>
      state.where((a) => a.isDefault).firstOrNull ?? state.firstOrNull;

  Future<void> _save(List<Address> list) async {
    state = list;
    await ref.read(userRepositoryProvider).saveAddresses(list);
  }

  Future<void> add(Address a) async {
    final list = List<Address>.from(state);
    if (list.isEmpty) a = a.copyWith(isDefault: true);
    if (a.isDefault) {
      for (var i = 0; i < list.length; i++) {
        list[i] = list[i].copyWith(isDefault: false);
      }
    }
    list.add(a);
    await _save(list);
  }

  Future<void> update(Address a) async {
    final list = [
      for (final x in state)
        if (x.id == a.id) a else (a.isDefault ? x.copyWith(isDefault: false) : x),
    ];
    await _save(list);
  }

  Future<void> remove(String id) async {
    final list = state.where((a) => a.id != id).toList();
    if (list.isNotEmpty && !list.any((a) => a.isDefault)) {
      list[0] = list[0].copyWith(isDefault: true);
    }
    await _save(list);
  }

  Future<void> setDefault(String id) async {
    await _save([for (final a in state) a.copyWith(isDefault: a.id == id)]);
  }
}

final addressesProvider =
    NotifierProvider<AddressesNotifier, List<Address>>(AddressesNotifier.new);
