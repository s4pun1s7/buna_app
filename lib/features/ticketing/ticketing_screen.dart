import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/common/index.dart';
import '../../services/error_handler.dart';

/// Ticket model for the festival
class Ticket {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final List<String> features;
  final bool isAvailable;
  final int remainingQuantity;
  final DateTime validFrom;
  final DateTime validUntil;

  const Ticket({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.currency = 'BGN',
    required this.features,
    required this.isAvailable,
    required this.remainingQuantity,
    required this.validFrom,
    required this.validUntil,
  });
}

/// Ticketing screen for purchasing festival tickets
class TicketingScreen extends ConsumerStatefulWidget {
  const TicketingScreen({super.key});

  @override
  ConsumerState<TicketingScreen> createState() => _TicketingScreenState();
}

class _TicketingScreenState extends ConsumerState<TicketingScreen> {
  List<Ticket> _tickets = [];
  bool _isLoading = true;
  String? _error;
  String _selectedTicketId = '';

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - in real app this would come from API
      final tickets = [
        Ticket(
          id: '1',
          name: 'Day Pass',
          description:
              'Access to all venues and events for a single day of your choice.',
          price: 25.0,
          features: [
            'Access to all venues',
            'All events on selected day',
            'Festival map and guide',
            'Free shuttle service',
          ],
          isAvailable: true,
          remainingQuantity: 150,
          validFrom: DateTime.now(),
          validUntil: DateTime.now().add(const Duration(days: 30)),
        ),
        Ticket(
          id: '2',
          name: 'Weekend Pass',
          description:
              'Access for Friday through Sunday - perfect for a weekend getaway.',
          price: 65.0,
          features: [
            'Access to all venues',
            'All events Friday-Sunday',
            'Festival map and guide',
            'Free shuttle service',
            'Exclusive weekend events',
            'Priority seating for performances',
          ],
          isAvailable: true,
          remainingQuantity: 75,
          validFrom: DateTime.now(),
          validUntil: DateTime.now().add(const Duration(days: 30)),
        ),
        Ticket(
          id: '3',
          name: 'Full Festival Pass',
          description:
              'Complete access to all three weeks of the festival - the ultimate experience.',
          price: 150.0,
          features: [
            'Access to all venues',
            'All events for entire festival',
            'Festival map and guide',
            'Free shuttle service',
            'Exclusive VIP events',
            'Priority seating for all performances',
            'Artist meet-and-greets',
            'Festival merchandise',
            'Backstage tours',
          ],
          isAvailable: true,
          remainingQuantity: 25,
          validFrom: DateTime.now(),
          validUntil: DateTime.now().add(const Duration(days: 30)),
        ),
        Ticket(
          id: '4',
          name: 'VIP Pass',
          description:
              'Premium access including exclusive events, artist meet-and-greets, and priority seating.',
          price: 250.0,
          features: [
            'All Full Festival Pass features',
            'Exclusive VIP lounge access',
            'Complimentary food and drinks',
            'Private artist meet-and-greets',
            'Guided tours with curators',
            'Premium parking',
            'Dedicated concierge service',
            'Limited edition festival merchandise',
            'Invitation to opening and closing parties',
          ],
          isAvailable: true,
          remainingQuantity: 10,
          validFrom: DateTime.now(),
          validUntil: DateTime.now().add(const Duration(days: 30)),
        ),
        Ticket(
          id: '5',
          name: 'Student Pass',
          description: 'Discounted access for students with valid ID.',
          price: 15.0,
          features: [
            'Access to all venues',
            'All events on selected day',
            'Festival map and guide',
            'Free shuttle service',
            'Student ID required',
          ],
          isAvailable: true,
          remainingQuantity: 50,
          validFrom: DateTime.now(),
          validUntil: DateTime.now().add(const Duration(days: 30)),
        ),
      ];

      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingIndicator();
    }

    if (_error != null) {
      return ErrorScreen(
        error: AppException(_error ?? 'Unknown error'),
        onRetry: _loadTickets,
      );
    }

    if (_tickets.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildHeader(),
        Expanded(child: _buildTicketsList()),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Festival Experience',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the perfect ticket option for your Buna Festival experience. Early bird discounts available until May 1st!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 16),
          _buildEarlyBirdBanner(),
        ],
      ),
    );
  }

  Widget _buildEarlyBirdBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.orange.shade600],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Early Bird Discount: 30% off until May 1st!',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tickets.length,
      itemBuilder: (context, index) {
        final ticket = _tickets[index];
        final isSelected = ticket.id == _selectedTicketId;

        return _buildTicketCard(ticket, isSelected);
      },
    );
  }

  Widget _buildTicketCard(Ticket ticket, bool isSelected) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: ticket.isAvailable ? () => _selectTicket(ticket) : null,
        borderRadius: BorderRadius.circular(12),
        child: Builder(
          builder: (context) {
            final scale = MediaQuery.textScaleFactorOf(context);
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ticket.name,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ticket.description,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '${ticket.price.toStringAsFixed(2)} ${ticket.currency}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      const Spacer(),
                      if (ticket.remainingQuantity <= 10)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Only ${ticket.remainingQuantity} left!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12 * scale,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'What\'s included:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...ticket.features.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(feature)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: ticket.isAvailable
                          ? () => _purchaseTicket(ticket)
                          : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        ticket.isAvailable ? 'Purchase Now' : 'Sold Out',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.confirmation_number,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Tickets Available',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Check back later for ticket sales'),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadTickets, child: const Text('Refresh')),
        ],
      ),
    );
  }

  void _selectTicket(Ticket ticket) {
    setState(() {
      _selectedTicketId = ticket.id;
    });
  }

  void _purchaseTicket(Ticket ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.confirmation_number,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Purchase ${ticket.name}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildPurchaseSummary(ticket),
              const SizedBox(height: 24),
              _buildPaymentForm(),
              const Spacer(),
              _buildPurchaseButton(ticket),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPurchaseSummary(Ticket ticket) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${ticket.name} x1'),
                Text('${ticket.price.toStringAsFixed(2)} ${ticket.currency}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Early Bird Discount'),
                Text(
                  '-${(ticket.price * 0.3).toStringAsFixed(2)} ${ticket.currency}',
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(ticket.price * 0.7).toStringAsFixed(2)} ${ticket.currency}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Information',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Card Number',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.credit_card),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'MM/YY',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.security),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Cardholder Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.person),
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseButton(Ticket ticket) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _confirmPurchase(ticket),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Builder(
          builder: (context) {
            final scale = MediaQuery.textScaleFactorOf(context);
            return Text(
              'Confirm Purchase',
              style: TextStyle(fontSize: 16 * scale),
            );
          },
        ),
      ),
    );
  }

  void _confirmPurchase(Ticket ticket) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Purchase Successful!'),
        content: Text(
          'Your ${ticket.name} has been purchased successfully. You will receive a confirmation email shortly.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
