


class QuickContact {
  final String name;
  final String avatarUrl;

  QuickContact({required this.name, required this.avatarUrl});

  static List<QuickContact> mockContacts = [
    // Male 1
    QuickContact(
      name: 'Alexander Cole',
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
    ),
    // Female
    QuickContact(
      name: 'Emma Watson',
      avatarUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150',
    ),
    // Male 2
    QuickContact(
      name: 'Julian Vance',
      avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150',
    ),
  ];
}