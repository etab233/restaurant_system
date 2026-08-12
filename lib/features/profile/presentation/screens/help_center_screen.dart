import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6F8),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: const Text(
          'Help Center',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F0E4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      size: 34,
                      color: Color(0xFF4A7A2E),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'How can we help?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Find answers to common questions or '
                    'contact our support team.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 10),

            const _FaqItem(
              question: 'How can I change my password?',
              answer:
                  'Go to Profile > Password & Security, '
                  'enter your current password and your new password, '
                  'then tap Change Password.',
            ),

            const _FaqItem(
              question: 'How can I update my profile?',
              answer:
                  'Go to Profile > Manage Profile. '
                  'From there you can update your name and phone number.',
            ),

            const _FaqItem(
              question: 'How can I place an order?',
              answer:
                  'Browse the available restaurants, select a meal, '
                  'add it to your cart, and continue to checkout.',
            ),

            const _FaqItem(
              question: 'How can I track my order?',
              answer:
                  'You can view your current and previous orders '
                  'from the Orders section of the application.',
            ),

            const _FaqItem(
              question: 'What should I do if I have a problem?',
              answer:
                  'If you cannot find a solution here, you can contact '
                  'our support team using the options below.',
            ),

            const SizedBox(height: 24),

            const Text(
              'Contact Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _ContactItem(
                    icon: Icons.email_outlined,
                    title: 'Email Support',
                    subtitle: 'support@nutrilink.com',
                    onTap: () {
                      // TODO: Open email client
                    },
                  ),

                  Divider(height: 1, indent: 64, color: Colors.grey.shade200),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Center(
              child: Text(
                'We are here to help you.',
                style: TextStyle(fontSize: 12.5, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        iconColor: const Color(0xFF4A7A2E),
        collapsedIconColor: Colors.grey,
        title: Text(
          question,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F0E4),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF4A7A2E), size: 21),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }
}
