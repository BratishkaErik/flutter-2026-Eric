import 'package:flutter/material.dart';

import 'contact_card.dart';
import 'contacts.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '${contacts.length} contacts',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: contacts.length,
            itemBuilder: (context, i) => ContactCard(contact: contacts[i]),
            separatorBuilder: (context, i) => const Divider(),
          ),
        ),
      ],
    );
  }
}
