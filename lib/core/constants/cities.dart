// Indian Cities Configuration
class IndianCities {
  // Popular/Featured Cities
  static const List<String> popular = [
    'Delhi NCR',
    'Bangalore',
    'Mumbai',
    'Hyderabad',
    'Kolkata',
    'Chennai',
    'Pune',
    'Ahmedabad',
  ];

  // All supported cities (alphabetical)
  static const List<String> all = [
    'Ahmedabad',
    'Bangalore',
    'Bhopal',
    'Chandigarh',
    'Chennai',
    'Coimbatore',
    'Delhi NCR',
    'Goa',
    'Gurgaon',
    'Hyderabad',
    'Indore',
    'Jaipur',
    'Kochi',
    'Kolkata',
    'Lucknow',
    'Mumbai',
    'Nagpur',
    'Noida',
    'Pune',
    'Surat',
    'Thiruvananthapuram',
    'Vadodara',
    'Visakhapatnam',
  ];

  // Get other cities (not in popular)
  static List<String> get others {
    return all.where((city) => !popular.contains(city)).toList();
  }

  // Search cities
  static List<String> search(String query) {
    if (query.isEmpty) return all;

    final lowerQuery = query.toLowerCase();
    return all.where((city) {
      return city.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Check if city is valid
  static bool isValid(String city) {
    return all.contains(city);
  }
}
