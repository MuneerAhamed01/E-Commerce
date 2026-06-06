import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:order_repository/order_repository.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({required this.orderId, super.key});

  final String orderId;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Order? _order;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final order = await context.read<OrderRepository>().getOrder(
        widget.orderId,
      );
      if (mounted) setState(() { _order = order; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_loading) {
      return const Scaffold(body: Center(child: TrendsLoader()));
    }

    if (_order == null) {
      return const Scaffold(
        appBar: TrendsAppBar(title: 'Order'),
        body: TrendsEmptyState(
          title: 'Order not found',
          icon: Icons.receipt_long_outlined,
        ),
      );
    }

    final order = _order!;
    final dateStr = order.createdAt != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt!)
        : '—';

    return Scaffold(
      appBar: TrendsAppBar(
        title: '#${order.id.substring(0, 8).toUpperCase()}',
      ),
      body: ListView(
        padding: const EdgeInsets.all(TrendsSpacing.marginMobile),
        children: [
          // Status banner
          Container(
            padding: const EdgeInsets.all(TrendsSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(TrendsSpacing.sm),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: colorScheme.primary),
                const SizedBox(width: TrendsSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.status.displayLabel,
                        style: TrendsTypography.labelMedium(
                          colorScheme.primary,
                        ),
                      ),
                      Text(
                        dateStr,
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
          const SizedBox(height: TrendsSpacing.lg),
          Text(
            'Items',
            style: TrendsTypography.headlineSmall(colorScheme.onSurface),
          ),
          const SizedBox(height: TrendsSpacing.md),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: TrendsSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TrendsTypography.bodyMedium(
                            colorScheme.onSurface,
                          ),
                        ),
                        if (item.variantLabel != null)
                          Text(
                            item.variantLabel!,
                            style: TrendsTypography.labelSmall(
                              colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '×${item.quantity}  ₹${item.lineTotal.toStringAsFixed(0)}',
                    style: TrendsTypography.labelMedium(colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: TrendsSpacing.xl),
          Text(
            'Delivery address',
            style: TrendsTypography.headlineSmall(colorScheme.onSurface),
          ),
          const SizedBox(height: TrendsSpacing.sm),
          Text(
            order.address.name,
            style: TrendsTypography.labelMedium(colorScheme.onSurface),
          ),
          Text(
            order.address.displayLine1,
            style: TrendsTypography.bodyMedium(colorScheme.onSurfaceVariant),
          ),
          Text(
            '${order.address.displayLine2}, ${order.address.displayLine3}',
            style: TrendsTypography.labelSmall(colorScheme.onSurfaceVariant),
          ),
          const Divider(height: TrendsSpacing.xl),
          Text(
            'Payment summary',
            style: TrendsTypography.headlineSmall(colorScheme.onSurface),
          ),
          const SizedBox(height: TrendsSpacing.md),
          _Line(
            label: 'Subtotal',
            value: '₹${order.subtotal.toStringAsFixed(0)}',
            colorScheme: colorScheme,
          ),
          if (order.couponDiscount > 0)
            _Line(
              label: 'Coupon (${order.couponCode ?? ''})',
              value: '–₹${order.couponDiscount.toStringAsFixed(0)}',
              colorScheme: colorScheme,
              valueColor: Colors.green.shade700,
            ),
          const SizedBox(height: TrendsSpacing.sm),
          const Divider(),
          const SizedBox(height: TrendsSpacing.sm),
          _Line(
            label: 'Total',
            value: '₹${order.total.toStringAsFixed(0)}',
            isTotal: true,
            colorScheme: colorScheme,
          ),
          if (order.paymentMethod != null) ...[
            const SizedBox(height: TrendsSpacing.sm),
            _Line(
              label: 'Payment method',
              value: order.paymentMethod == 'razorpay' ? 'Online' : 'Cash on delivery',
              colorScheme: colorScheme,
            ),
          ],
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
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
