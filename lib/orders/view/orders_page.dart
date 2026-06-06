import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:order_repository/order_repository.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:trends/app/router/app_router.dart';
import 'package:trends/orders/cubit/orders_cubit.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit(
        orderRepository: context.read<OrderRepository>(),
      )..loadOrders(context.read<AppBloc>().state.user?.id ?? ''),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatelessWidget {
  const _OrdersView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const TrendsAppBar(title: 'My Orders'),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state.status == OrdersStatus.loading) {
            return const Center(child: TrendsLoader());
          }
          if (state.status == OrdersStatus.failure) {
            return TrendsErrorView(
              message: 'Could not load orders.',
              onRetry: () {
                final userId =
                    context.read<AppBloc>().state.user?.id ?? '';
                context.read<OrdersCubit>().loadOrders(userId);
              },
            );
          }
          if (state.orders.isEmpty) {
            return TrendsEmptyState(
              title: 'No orders yet',
              subtitle: 'Your order history will appear here.',
              icon: Icons.receipt_long_outlined,
              action: TrendsButton(
                label: 'Start shopping',
                expand: false,
                onPressed: () => context.go(AppRoutes.home),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(TrendsSpacing.marginMobile),
            itemCount: state.orders.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: TrendsSpacing.md),
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return _OrderCard(order: order, colorScheme: colorScheme);
            },
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.colorScheme});
  final Order order;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final dateStr = order.createdAt != null
        ? DateFormat('dd MMM yyyy').format(order.createdAt!)
        : '—';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TrendsSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order #${order.id.substring(0, 8).toUpperCase()}',
                    style:
                        TrendsTypography.labelMedium(colorScheme.onSurface),
                  ),
                ),
                _StatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: TrendsSpacing.xs),
            Text(
              dateStr,
              style: TrendsTypography.labelSmall(
                colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: TrendsSpacing.sm),
            ...order.items.take(2).map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: TrendsSpacing.xs),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: TrendsTypography.bodyMedium(
                          colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '×${item.quantity}',
                      style: TrendsTypography.labelSmall(
                        colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (order.itemCount > 2)
              Text(
                '+${order.itemCount - 2} more item(s)',
                style: TrendsTypography.labelSmall(
                  colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: TrendsSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.itemCount} item${order.itemCount != 1 ? 's' : ''} · ₹${order.total.toStringAsFixed(0)}',
                  style:
                      TrendsTypography.labelMedium(colorScheme.onSurface),
                ),
                TextButton(
                  onPressed: () => context.push(
                    '${AppRoutes.orderDetail}/${order.id}',
                  ),
                  child: const Text('View details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      OrderStatus.delivered => (Colors.green.shade50, Colors.green.shade800),
      OrderStatus.cancelled ||
      OrderStatus.refunded => (Colors.red.shade50, Colors.red.shade800),
      OrderStatus.shipped => (Colors.blue.shade50, Colors.blue.shade800),
      _ => (
          Theme.of(context).colorScheme.surfaceContainerLow,
          Theme.of(context).colorScheme.onSurfaceVariant,
        ),
    };

    return TrendsBadge(
      label: status.displayLabel,
      backgroundColor: bg,
      foregroundColor: fg,
    );
  }
}
