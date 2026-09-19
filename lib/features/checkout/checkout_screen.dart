import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_image.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/state_views.dart';
import '../../data/models/models.dart';
import '../../navigation/app_routes.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/user_provider.dart';
import '../profile/addresses_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _step = 0;
  String? _addressId;
  late final TextEditingController _phone;
  final _comment = TextEditingController();
  PaymentMethod _payment = PaymentMethod.cash;
  bool _placing = false;
  final _phoneKey = GlobalKey<FormState>();

  static const _steps = ['Manzil', 'Telefon', "To'lov", 'Tasdiqlash'];

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _phone = TextEditingController(text: Formatters.phone(user.phone));
    _addressId = ref.read(addressesProvider.notifier).defaultAddress?.id;
  }

  @override
  void dispose() {
    _phone.dispose();
    _comment.dispose();
    super.dispose();
  }

  Address? get _address {
    final list = ref.read(addressesProvider);
    for (final a in list) {
      if (a.id == _addressId) return a;
    }
    return list.firstOrNull;
  }

  bool get _canContinue => switch (_step) {
        0 => _address != null,
        1 => _phoneValid(_phone.text),
        _ => true,
      };

  static bool _phoneValid(String v) {
    final digits = v.replaceAll(RegExp(r'\D'), '');
    return digits.length == 12 && digits.startsWith('998');
  }

  void _next() {
    if (_step == 1 && !(_phoneKey.currentState?.validate() ?? false)) return;
    HapticFeedback.selectionClick();
    setState(() => _step++);
  }

  void _back() {
    if (_step == 0) {
      context.pop();
    } else {
      setState(() => _step--);
    }
  }

  Future<void> _placeOrder() async {
    final address = _address;
    if (address == null) return;
    setState(() => _placing = true);
    try {
      final order = await ref.read(ordersProvider.notifier).placeOrder(
            address: address.full,
            phone: _phone.text,
            paymentMethod: _payment,
            comment: _comment.text.trim(),
          );
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      context.pushReplacement(AppRoutes.orderSuccessPath(order.id));
    } catch (e) {
      if (!mounted) return;
      setState(() => _placing = false);
      showAppSnackBar(context, 'Xatolik: buyurtma yaratilmadi', icon: Icons.error_outline_rounded, iconColor: AppColors.danger);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final c = context.colors;

    if (cart.selected.isEmpty && !_placing) {
      return Scaffold(
        appBar: AppBar(title: const Text('Buyurtma berish')),
        body: EmptyView(
          icon: Icons.shopping_bag_outlined,
          title: 'Tanlangan mahsulotlar yo\'q',
          subtitle: 'Savatda kamida bitta mahsulotni tanlang',
          actionLabel: 'Savatga qaytish',
          onAction: () => context.pop(),
        ),
      );
    }

    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: _back),
          title: const Text('Buyurtma berish'),
        ),
        body: Column(
          children: [
            _Stepper(steps: _steps, current: _step),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOutCubic,
                transitionBuilder: (child, a) => FadeTransition(
                  opacity: a,
                  child: SlideTransition(
                    position: Tween(begin: const Offset(0.05, 0), end: Offset.zero).animate(a),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey(_step),
                  child: switch (_step) {
                    0 => _buildAddressStep(),
                    1 => _buildPhoneStep(),
                    2 => _buildPaymentStep(),
                    _ => _buildConfirmStep(cart),
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: c.surface,
            border: Border(top: BorderSide(color: c.border)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text('Jami', style: context.text.bodyMedium?.copyWith(color: c.textSecondary)),
                    const Spacer(),
                    Text(Formatters.price(cart.total), style: context.text.titleLarge?.copyWith(color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 10),
                AppButton(
                  label: _step == _steps.length - 1 ? 'Buyurtmani tasdiqlash' : 'Davom etish',
                  icon: _step == _steps.length - 1 ? Icons.check_rounded : Icons.arrow_forward_rounded,
                  loading: _placing,
                  onPressed: !_canContinue
                      ? null
                      : _step == _steps.length - 1
                          ? _placeOrder
                          : _next,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- 1. Manzil ----------
  Widget _buildAddressStep() {
    final addresses = ref.watch(addressesProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        Text('Yetkazib berish manzili', style: context.text.titleMedium),
        const SizedBox(height: 10),
        if (addresses.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text("Manzil qo'shilmagan", style: context.text.bodyMedium, textAlign: TextAlign.center),
          ),
        for (final a in addresses)
          _SelectCard(
            selected: (_addressId ?? addresses.first.id) == a.id,
            onTap: () => setState(() => _addressId = a.id),
            icon: a.title.toLowerCase() == 'ish' ? Icons.work_outline_rounded : Icons.home_outlined,
            title: a.title,
            subtitle: a.full,
          ),
        const SizedBox(height: 4),
        OutlinedButton.icon(
          onPressed: () async {
            final added = await showAddressEditor(context);
            if (added != null) {
              await ref.read(addressesProvider.notifier).add(added);
              setState(() => _addressId = added.id);
            }
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text("Yangi manzil qo'shish"),
        ),
        const SizedBox(height: 16),
        _DeliveryInfo(),
      ],
    );
  }

  // ---------- 2. Telefon ----------
  Widget _buildPhoneStep() {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        Text('Telefon raqami', style: context.text.titleMedium),
        const SizedBox(height: 6),
        Text(
          "Kuryer siz bilan shu raqam orqali bog'lanadi",
          style: context.text.bodySmall,
        ),
        const SizedBox(height: 14),
        Form(
          key: _phoneKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: TextFormField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            autofocus: true,
            inputFormatters: [_UzPhoneFormatter()],
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: '+998 90 123 45 67',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            validator: (v) => _phoneValid(v ?? '') ? null : "To'g'ri raqam kiriting (+998 XX XXX XX XX)",
          ),
        ),
        const SizedBox(height: 20),
        Text("Kuryer uchun izoh (ixtiyoriy)", style: context.text.titleMedium),
        const SizedBox(height: 10),
        TextField(
          controller: _comment,
          maxLines: 3,
          maxLength: 200,
          decoration: const InputDecoration(hintText: 'Masalan: domofon ishlamaydi, qo\'ng\'iroq qiling'),
        ),
      ],
    );
  }

  // ---------- 3. To'lov ----------
  Widget _buildPaymentStep() {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        Text("To'lov usuli", style: context.text.titleMedium),
        const SizedBox(height: 10),
        for (final m in PaymentMethod.values)
          _SelectCard(
            selected: _payment == m,
            onTap: () => setState(() => _payment = m),
            icon: switch (m) {
              PaymentMethod.cash => Icons.payments_outlined,
              PaymentMethod.card => Icons.credit_card_rounded,
              PaymentMethod.online => Icons.phone_iphone_rounded,
            },
            title: m.label,
            subtitle: m.description,
          ),
        if (AppConfig.isDemoPayment && _payment != PaymentMethod.cash)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Color(0xFF7C4A03), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "DEMO PAYMENT rejimi: real pul yechilmaydi. To'lov muvaffaqiyatli deb qabul qilinadi.",
                    style: context.text.labelSmall?.copyWith(color: const Color(0xFF7C4A03)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ---------- 4. Tasdiqlash ----------
  Widget _buildConfirmStep(CartState cart) {
    final c = context.colors;
    final address = _address;
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        _ConfirmBlock(
          icon: Icons.location_on_outlined,
          title: address?.title ?? 'Manzil',
          value: address?.full ?? '-',
          onEdit: () => setState(() => _step = 0),
        ),
        _ConfirmBlock(
          icon: Icons.phone_outlined,
          title: 'Telefon',
          value: _phone.text,
          onEdit: () => setState(() => _step = 1),
        ),
        _ConfirmBlock(
          icon: Icons.account_balance_wallet_outlined,
          title: "To'lov usuli",
          value: _payment.label,
          onEdit: () => setState(() => _step = 2),
        ),
        const SizedBox(height: 8),
        Text('Buyurtma tarkibi (${cart.selected.length})', style: context.text.titleMedium),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: Column(
            children: [
              for (final (i, item) in cart.selected.indexed)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: i == 0 ? null : Border(top: BorderSide(color: c.border)),
                  ),
                  child: Row(
                    children: [
                      AppImage(item.product.image, width: 52, height: 52, borderRadius: BorderRadius.circular(10)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: context.text.bodySmall?.copyWith(color: c.text)),
                            Text('${item.quantity} x ${Formatters.price(item.product.price)}', style: context.text.labelSmall),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(Formatters.price(item.total), style: context.text.labelMedium),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: Column(
            children: [
              _row(context, 'Mahsulotlar summasi', Formatters.price(cart.subtotal)),
              if (cart.discount > 0) _row(context, 'Chegirma', '-${Formatters.price(cart.discount)}', color: AppColors.danger),
              _row(context, 'Yetkazib berish', cart.deliveryFee == 0 ? 'Bepul' : Formatters.price(cart.deliveryFee), color: cart.deliveryFee == 0 ? AppColors.success : null),
              const Divider(height: 18),
              Row(
                children: [
                  Text('Yakuniy summa', style: context.text.titleMedium),
                  const Spacer(),
                  Text(Formatters.price(cart.total), style: context.text.titleMedium?.copyWith(color: AppColors.primary)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(BuildContext context, String l, String v, {Color? color}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Text(l, style: context.text.bodyMedium?.copyWith(color: context.colors.textSecondary)),
            const Spacer(),
            Text(v, style: context.text.labelMedium?.copyWith(color: color)),
          ],
        ),
      );
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.steps, required this.current});
  final List<String> steps;
  final int current;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Expanded(
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: AppDurations.normal,
                    height: 5,
                    decoration: BoxDecoration(
                      color: i <= current ? AppColors.primary : c.border,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    steps[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.labelSmall?.copyWith(
                      color: i <= current ? AppColors.primary : c.textTertiary,
                      fontWeight: i == current ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (i != steps.length - 1) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _SelectCard extends StatelessWidget {
  const _SelectCard({
    required this.selected,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: AnimatedContainer(
            duration: AppDurations.fast,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: selected ? AppColors.primary : c.border, width: selected ? 1.6 : 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: (selected ? AppColors.primary : c.textSecondary).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: selected ? AppColors.primary : c.textSecondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.text.titleSmall),
                      const SizedBox(height: 2),
                      Text(subtitle, style: context.text.labelSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: AppDurations.fast,
                  child: Icon(
                    selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                    key: ValueKey(selected),
                    color: selected ? AppColors.primary : c.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmBlock extends StatelessWidget {
  const _ConfirmBlock({required this.icon, required this.title, required this.value, required this.onEdit});
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
      decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.labelSmall),
                Text(value, style: context.text.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          TextButton(onPressed: onEdit, child: const Text("O'zgartirish")),
        ],
      ),
    );
  }
}

class _DeliveryInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule_rounded, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Taxminiy yetkazib berish: ertaga, 10:00 – 20:00',
              style: context.text.labelMedium?.copyWith(color: AppColors.primaryDark),
            ),
          ),
        ],
      ),
    );
  }
}

/// +998 XX XXX XX XX formatlovchi.
class _UzPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (!digits.startsWith('998')) digits = '998$digits';
    digits = digits.substring(0, digits.length.clamp(0, 12));
    final b = StringBuffer('+');
    for (var i = 0; i < digits.length; i++) {
      if (i == 3 || i == 5 || i == 8 || i == 10) b.write(' ');
      b.write(digits[i]);
    }
    final text = b.toString();
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}
