import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_repository/order_repository.dart';
import 'package:trends/core/errors/trends_error_handler.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:trends/app/router/app_router.dart';
import 'package:trends/cart/bloc/cart_bloc.dart';
import 'package:trends/checkout/cubit/checkout_cubit.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<AppBloc>().state.user?.id;
    if (userId != null) {
      context.read<CheckoutCubit>().loadAddresses(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cart = context.watch<CartBloc>().state.cart;

    return BlocListener<CheckoutCubit, CheckoutState>(
      listenWhen: (prev, curr) => prev.orderStatus != curr.orderStatus,
      listener: (context, state) {
        if (state.orderStatus == OrderPlacementStatus.success) {
          TrendsErrorHandler.showSuccess(
            context,
            'Order placed successfully!',
          );
          context.go(AppRoutes.orders);
        } else if (state.orderStatus == OrderPlacementStatus.failure) {
          TrendsErrorHandler.showOrderFailure(
            context,
            onRetry: () {
              final userId = context.read<AppBloc>().state.user?.id;
              if (userId == null) return;
              context.read<CheckoutCubit>().placeOrder(
                userId: userId,
                cart: cart,
              );
            },
          );
        }
      },
      child: BlocBuilder<CheckoutCubit, CheckoutState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(TrendsSpacing.marginMobile),
            children: [
              // Delivery address
              Text(
                'Delivery address',
                style: TrendsTypography.headlineSmall(colorScheme.onSurface),
              ),
              const SizedBox(height: TrendsSpacing.md),
              if (state.addressStatus == AddressStatus.loading)
                const Center(child: TrendsLoader())
              else if (state.addresses.isNotEmpty)
                ...state.addresses.map(
                  (address) => _AddressTile(
                    address: address,
                    isSelected: state.selectedAddress?.id == address.id,
                    onTap: () => context
                        .read<CheckoutCubit>()
                        .selectAddress(address),
                  ),
                ),
              TextButton.icon(
                onPressed: () => _showAddAddressSheet(context),
                icon: const Icon(Icons.add),
                label: const Text('Add new address'),
              ),
              const SizedBox(height: TrendsSpacing.lg),
              const Divider(),
              const SizedBox(height: TrendsSpacing.lg),
              // Order summary
              Text(
                'Order summary',
                style: TrendsTypography.headlineSmall(colorScheme.onSurface),
              ),
              const SizedBox(height: TrendsSpacing.md),
              ...cart.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: TrendsSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item.name}${item.variantLabel != null ? ' (${item.variantLabel})' : ''}',
                          style: TrendsTypography.bodyMedium(
                            colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        '×${item.quantity}  ₹${item.lineTotal.toStringAsFixed(0)}',
                        style: TrendsTypography.labelMedium(
                          colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: TrendsSpacing.sm),
              _SummaryLine(
                label: 'Subtotal',
                value: '₹${cart.subtotal.toStringAsFixed(0)}',
                colorScheme: colorScheme,
              ),
              if (cart.couponDiscount > 0)
                _SummaryLine(
                  label: 'Discount',
                  value: '–₹${cart.couponDiscount.toStringAsFixed(0)}',
                  valueColor: Colors.green.shade700,
                  colorScheme: colorScheme,
                ),
              const SizedBox(height: TrendsSpacing.sm),
              _SummaryLine(
                label: 'Total',
                value: '₹${cart.total.toStringAsFixed(0)}',
                isTotal: true,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: TrendsSpacing.xl),
              // Payment
              Text(
                'Payment',
                style: TrendsTypography.headlineSmall(colorScheme.onSurface),
              ),
              const SizedBox(height: TrendsSpacing.md),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(TrendsSpacing.md),
                  child: Row(
                    children: [
                      const Icon(Icons.delivery_dining_outlined),
                      const SizedBox(width: TrendsSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cash on Delivery',
                              style: TrendsTypography.labelMedium(
                                colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              'Pay when delivered',
                              style: TrendsTypography.labelSmall(
                                colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.radio_button_checked),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: TrendsSpacing.sm),
              Opacity(
                opacity: 0.55,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () =>
                        TrendsErrorHandler.showPaymentUnavailable(context),
                    child: Padding(
                      padding: const EdgeInsets.all(TrendsSpacing.md),
                      child: Row(
                        children: [
                          const Icon(Icons.credit_card_outlined),
                          const SizedBox(width: TrendsSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Online payment (coming soon)',
                                  style: TrendsTypography.labelMedium(
                                    colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  'Razorpay — tap to learn more',
                                  style: TrendsTypography.labelSmall(
                                    colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.radio_button_unchecked),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: TrendsSpacing.xl),
              TrendsButton(
                label: 'Place order  ₹${cart.total.toStringAsFixed(0)}',
                isLoading: state.orderStatus == OrderPlacementStatus.loading,
                onPressed: state.selectedAddress == null ||
                        state.orderStatus == OrderPlacementStatus.loading
                    ? null
                    : () async {
                        final userId =
                            context.read<AppBloc>().state.user?.id;
                        if (userId == null) return;
                        await context.read<CheckoutCubit>().placeOrder(
                          userId: userId,
                          cart: context.read<CartBloc>().state.cart,
                        );
                      },
              ),
              if (state.selectedAddress == null)
                Padding(
                  padding: const EdgeInsets.only(top: TrendsSpacing.sm),
                  child: Text(
                    'Please add a delivery address to continue.',
                    style: TrendsTypography.labelSmall(TrendsColors.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: TrendsSpacing.xl),
            ],
          );
        },
      ),
    );
  }

  void _showAddAddressSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<CheckoutCubit>(),
        child: const _AddAddressSheet(),
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  final Address address;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: isSelected
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TrendsSpacing.sm),
        child: Padding(
          padding: const EdgeInsets.all(TrendsSpacing.md),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? colorScheme.primary : null,
              ),
              const SizedBox(width: TrendsSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.name,
                      style: TrendsTypography.labelMedium(
                        colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      address.displayLine1,
                      style: TrendsTypography.bodyMedium(
                        colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${address.displayLine2}, ${address.displayLine3}',
                      style: TrendsTypography.labelSmall(
                        colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    required this.colorScheme,
    this.isTotal = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final ColorScheme colorScheme;
  final bool isTotal;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? TrendsTypography.labelMedium(colorScheme.onSurface)
              : TrendsTypography.bodyMedium(colorScheme.onSurfaceVariant),
        ),
        Text(
          value,
          style: isTotal
              ? TrendsTypography.headlineSmall(colorScheme.onSurface)
              : TrendsTypography.labelMedium(
                  valueColor ?? colorScheme.onSurface,
                ),
        ),
      ],
    );
  }
}

class _AddAddressSheet extends StatefulWidget {
  const _AddAddressSheet();

  @override
  State<_AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<_AddAddressSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _line1Ctrl = TextEditingController();
  final _line2Ctrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _line1Ctrl.dispose();
    _line2Ctrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _pincodeCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        builder: (_, controller) => Form(
          key: _formKey,
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(TrendsSpacing.sheetPadding),
            children: [
              Text(
                'New address',
                style: TrendsTypography.headlineSmall(colorScheme.onSurface),
              ),
              const SizedBox(height: TrendsSpacing.lg),
              _field('Full name', _nameCtrl, required: true),
              const SizedBox(height: TrendsSpacing.md),
              _field('Address line 1', _line1Ctrl, required: true),
              const SizedBox(height: TrendsSpacing.md),
              _field('Address line 2 (optional)', _line2Ctrl),
              const SizedBox(height: TrendsSpacing.md),
              Row(
                children: [
                  Expanded(child: _field('City', _cityCtrl, required: true)),
                  const SizedBox(width: TrendsSpacing.md),
                  Expanded(
                    child: _field('State', _stateCtrl, required: true),
                  ),
                ],
              ),
              const SizedBox(height: TrendsSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _field(
                      'Pincode',
                      _pincodeCtrl,
                      required: true,
                      keyboard: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: TrendsSpacing.md),
                  Expanded(
                    child: _field(
                      'Phone',
                      _phoneCtrl,
                      required: true,
                      keyboard: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TrendsSpacing.xl),
              TrendsButton(
                label: 'Save address',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    bool required = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(labelText: label),
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
          : null,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final address = Address(
      id: '',
      name: _nameCtrl.text.trim(),
      line1: _line1Ctrl.text.trim(),
      line2: _line2Ctrl.text.trim().isEmpty ? null : _line2Ctrl.text.trim(),
      city: _cityCtrl.text.trim(),
      state: _stateCtrl.text.trim(),
      pincode: _pincodeCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    );
    final userId = context.read<AppBloc>().state.user?.id;
    if (userId != null) {
      context.read<CheckoutCubit>().saveAddress(
        userId: userId,
        address: address,
      );
    }
    Navigator.of(context).pop();
  }
}
