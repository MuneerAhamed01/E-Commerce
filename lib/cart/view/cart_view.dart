import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trends/app/router/app_router.dart';
import 'package:trends/cart/bloc/cart_bloc.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.status == CartStatus.loading) {
          return const Center(child: TrendsLoader());
        }

        final cart = state.cart;

        if (cart.isEmpty) {
          return TrendsEmptyState(
            title: 'Your cart is empty',
            subtitle: 'Browse the store to add items.',
            icon: Icons.shopping_bag_outlined,
            action: TrendsButton(
              label: 'Start shopping',
              expand: false,
              onPressed: () => context.go(AppRoutes.home),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: TrendsSpacing.md,
                ),
                itemCount: cart.items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return Dismissible(
                    key: ValueKey(item.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => context.read<CartBloc>().add(
                      CartItemRemoved(item.id),
                    ),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(
                        right: TrendsSpacing.lg,
                      ),
                      color: TrendsColors.error,
                      child: const Icon(
                        Icons.delete_outline,
                        color: TrendsColors.onError,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TrendsSpacing.marginMobile,
                        vertical: TrendsSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              TrendsSpacing.sm,
                            ),
                            child: SizedBox(
                              width: 72,
                              height: 96,
                              child: item.imageUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: item.imageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : const ColoredBox(
                                      color: TrendsColors.surfaceContainer,
                                      child: Icon(
                                        Icons.image_outlined,
                                        color: TrendsColors.onSurfaceVariant,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: TrendsSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TrendsTypography.bodyMedium(
                                    colorScheme.onSurface,
                                  ),
                                ),
                                if (item.variantLabel != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    item.variantLabel!,
                                    style: TrendsTypography.labelSmall(
                                      colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: TrendsSpacing.xs),
                                Text(
                                  '₹${item.price.toStringAsFixed(0)}',
                                  style: TrendsTypography.labelMedium(
                                    colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: TrendsSpacing.sm),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add, size: 18),
                                padding: EdgeInsets.zero,
                                onPressed: () =>
                                    context.read<CartBloc>().add(
                                      CartItemQuantityChanged(
                                        itemId: item.id,
                                        quantity: item.quantity + 1,
                                      ),
                                    ),
                              ),
                              Text(
                                '${item.quantity}',
                                style: TrendsTypography.labelMedium(
                                  colorScheme.onSurface,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove, size: 18),
                                padding: EdgeInsets.zero,
                                onPressed: () =>
                                    context.read<CartBloc>().add(
                                      CartItemQuantityChanged(
                                        itemId: item.id,
                                        quantity: item.quantity - 1,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Coupon + summary
            _CartSummaryPanel(
              state: state,
              couponController: _couponController,
              colorScheme: colorScheme,
            ),
          ],
        );
      },
    );
  }
}

class _CartSummaryPanel extends StatelessWidget {
  const _CartSummaryPanel({
    required this.state,
    required this.couponController,
    required this.colorScheme,
  });

  final CartState state;
  final TextEditingController couponController;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final cart = state.cart;

    return Container(
      padding: const EdgeInsets.all(TrendsSpacing.marginMobile),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Coupon input
            if (cart.couponCode == null) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: couponController,
                      decoration: const InputDecoration(
                        hintText: 'Coupon code',
                        isDense: true,
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                  ),
                  const SizedBox(width: TrendsSpacing.sm),
                  TextButton(
                    onPressed: state.couponStatus == CouponStatus.validating
                        ? null
                        : () => context.read<CartBloc>().add(
                              CartCouponApplied(couponController.text),
                            ),
                    child: state.couponStatus == CouponStatus.validating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Apply'),
                  ),
                ],
              ),
              if (state.couponStatus == CouponStatus.invalid &&
                  state.couponError != null)
                Padding(
                  padding: const EdgeInsets.only(top: TrendsSpacing.xs),
                  child: Text(
                    state.couponError!,
                    style: TrendsTypography.labelSmall(TrendsColors.error),
                  ),
                ),
            ] else
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  const SizedBox(width: TrendsSpacing.xs),
                  Text(
                    '${cart.couponCode} applied',
                    style: TrendsTypography.labelMedium(Colors.green.shade700),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.read<CartBloc>().add(
                      const CartCouponRemoved(),
                    ),
                    child: const Text('Remove'),
                  ),
                ],
              ),
            const SizedBox(height: TrendsSpacing.md),
            _PriceLine(
              label: 'Subtotal (${cart.itemCount} items)',
              value: '₹${cart.subtotal.toStringAsFixed(0)}',
              colorScheme: colorScheme,
            ),
            if (cart.couponDiscount > 0) ...[
              const SizedBox(height: TrendsSpacing.xs),
              _PriceLine(
                label: 'Coupon discount',
                value: '– ₹${cart.couponDiscount.toStringAsFixed(0)}',
                valueColor: Colors.green.shade700,
                colorScheme: colorScheme,
              ),
            ],
            const SizedBox(height: TrendsSpacing.sm),
            const Divider(),
            const SizedBox(height: TrendsSpacing.sm),
            _PriceLine(
              label: 'Total',
              value: '₹${cart.total.toStringAsFixed(0)}',
              isTotal: true,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: TrendsSpacing.md),
            TrendsButton(
              label: 'Proceed to checkout',
              onPressed: () => context.push(AppRoutes.checkout),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({
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
