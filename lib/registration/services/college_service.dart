import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/college_model.dart';

class CollegeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Search colleges by name (case-insensitive)
  Future<List<CollegeModel>> searchColleges(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      // Convert query to lowercase for case-insensitive search
      final searchQuery = query.toLowerCase().trim();
      List<CollegeModel> results = [];

      // First, try to get from Firestore
      try {
        final QuerySnapshot approvedColleges =
            await _firestore
                .collection('colleges')
                .where('isApproved', isEqualTo: true)
                .get();

        for (var doc in approvedColleges.docs) {
          final college = CollegeModel.fromMap(
            doc.id,
            doc.data() as Map<String, dynamic>,
          );

          // Check if college name starts with the search query
          if (college.name.toLowerCase().startsWith(searchQuery)) {
            results.add(college);
          }
        }
      } catch (e) {
        // If Firestore fails, use sample data
        print('Firestore search failed, using sample data: $e');
      }

      // If no results from Firestore, use sample data
      if (results.isEmpty) {
        final sampleColleges = [
          // IITs
          'IIT Delhi',
          'IIT Bombay',
          'IIT Madras',
          'IIT Kanpur',
          'IIT Kharagpur',
          'IIT Roorkee', 'IIT Guwahati', 'IIT Hyderabad', 'IIT Gandhinagar',
          'IIT Ropar', 'IIT Patna', 'IIT Jodhpur', 'IIT Indore', 'IIT Mandi',
          'IIT Varanasi', 'IIT Bhubaneswar', 'IIT Dhanbad', 'IIT Tirupati',
          'IIT Palakkad', 'IIT Jammu', 'IIT Dharwad', 'IIT Bhilai', 'IIT Goa',

          // NITs
          'NIT Delhi',
          'NIT Mumbai',
          'NIT Chennai',
          'NIT Kolkata',
          'NIT Bangalore',
          'NIT Hyderabad', 'NIT Warangal', 'NIT Surathkal', 'NIT Trichy',
          'NIT Rourkela', 'NIT Calicut', 'NIT Durgapur', 'NIT Silchar',
          'NIT Hamirpur', 'NIT Jalandhar', 'NIT Kurukshetra', 'NIT Patna',
          'NIT Raipur', 'NIT Agartala', 'NIT Srinagar', 'NIT Meghalaya',
          'NIT Manipur', 'NIT Mizoram', 'NIT Nagaland', 'NIT Puducherry',
          'NIT Sikkim', 'NIT Uttarakhand', 'NIT Arunachal Pradesh',
          'NIT Tripura',
          'NIT Goa',
          'NIT Lakshadweep',
          'NIT Andaman and Nicobar',
          'NIT Dadra and Nagar Haveli', 'NIT Daman and Diu', 'NIT Chandigarh',

          // BITS
          'BITS Pilani', 'BITS Goa', 'BITS Hyderabad', 'BITS Dubai',

          // Other Premier Institutes
          'Delhi University',
          'Delhi Technological University',
          'Delhi College of Engineering',
          'Jawaharlal Nehru University',
          'Jamia Millia Islamia',
          'Aligarh Muslim University',
          'Banaras Hindu University',
          'University of Hyderabad',
          'Punjab University',
          'Mumbai University', 'Calcutta University', 'Madras University',
          'Bangalore University', 'Osmania University', 'Andhra University',
          'Karnataka University', 'Gujarat University', 'Rajasthan University',
          'Madhya Pradesh University',
          'Uttar Pradesh University',
          'Bihar University',
          'Assam University', 'Manipur University', 'Mizoram University',
          'Nagaland University', 'Tripura University', 'Sikkim University',
          'Arunachal Pradesh University',
          'Goa University',
          'Puducherry University',
          'Chandigarh University',
          'Delhi Public School',
          'Delhi Institute of Technology',
          'Banasthali Vidyapith',
          'Birla Institute of Technology',
          'Bharati Vidyapeeth University',
          'BMS College of Engineering',
          'BMS Institute of Technology',
          'BMS College for Women',
          'St. Xavier\'s College',
          'Loyola College',
          'Christ University',
          'St. Joseph\'s College',
          'St. Stephen\'s College',
          'Hindu College',
          'Ramjas College',
          'Miranda House',
          'Lady Shri Ram College', 'Gargi College', 'Kamala Nehru College',
          'Indraprastha College', 'Daulat Ram College', 'Maitreyi College',
          'Shri Ram College of Commerce',
          'Hansraj College',
          'Kirori Mal College',
          'Acharya Narendra Dev College',
          'Bhaskaracharya College',
          'Deen Dayal Upadhyaya College',
          'Deshbandhu College',
          'Dyal Singh College',
          'Gandhi Memorial National College',
          'Guru Gobind Singh College',
          'Keshav Mahavidyalaya',
          'Maharaja Agrasen College',
          'Maharishi Valmiki College',
          'Motilal Nehru College',
          'P.G.D.A.V. College',
          'Rajdhani College', 'Ramanujan College', 'Satyawati College',
          'Shahid Bhagat Singh College', 'Shivaji College', 'Shyam Lal College',
          'Sri Aurobindo College', 'Sri Guru Nanak Dev Khalsa College',
          'Sri Guru Tegh Bahadur Khalsa College', 'Swami Shraddhanand College',
          'Vivekananda College',
          'Zakir Husain College',
          'Zakir Husain Delhi College',
        ];

        for (String collegeName in sampleColleges) {
          if (collegeName.toLowerCase().startsWith(searchQuery)) {
            results.add(
              CollegeModel(
                id: 'sample_${collegeName.replaceAll(' ', '_').toLowerCase()}',
                name: collegeName,
                isApproved: true,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );
          }
        }
      }

      // Sort results by relevance (exact matches first, then partial matches)
      results.sort((a, b) {
        final aName = a.name.toLowerCase();
        final bName = b.name.toLowerCase();

        // Exact match gets priority
        if (aName == searchQuery && bName != searchQuery) return -1;
        if (bName == searchQuery && aName != searchQuery) return 1;

        // Then sort by name
        return aName.compareTo(bName);
      });

      // Limit results to 10 for better performance
      return results.take(10).toList();
    } catch (e) {
      throw Exception('Failed to search colleges: $e');
    }
  }

  // Get all approved colleges
  Future<List<CollegeModel>> getAllApprovedColleges() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore
              .collection('colleges')
              .where('isApproved', isEqualTo: true)
              .orderBy('name')
              .get();

      return snapshot.docs
          .map(
            (doc) => CollegeModel.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get colleges: $e');
    }
  }

  // Add college to pending colleges collection
  Future<String> addPendingCollege(String collegeName) async {
    try {
      final pendingCollege = CollegeModel(
        id: '', // Will be assigned by Firestore
        name: collegeName.trim(),
        isApproved: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final DocumentReference docRef = await _firestore
          .collection('pending_colleges')
          .add(pendingCollege.toMap());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add pending college: $e');
    }
  }

  // Check if college exists (approved or pending)
  Future<bool> collegeExists(String collegeName) async {
    try {
      final searchQuery = collegeName.toLowerCase().trim();

      // Check in approved colleges
      final QuerySnapshot approvedColleges =
          await _firestore
              .collection('colleges')
              .where('isApproved', isEqualTo: true)
              .get();

      for (var doc in approvedColleges.docs) {
        final college = CollegeModel.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
        if (college.name.toLowerCase() == searchQuery) {
          return true;
        }
      }

      // Check in pending colleges
      final QuerySnapshot pendingColleges =
          await _firestore.collection('pending_colleges').get();

      for (var doc in pendingColleges.docs) {
        final college = CollegeModel.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
        if (college.name.toLowerCase() == searchQuery) {
          return true;
        }
      }

      return false;
    } catch (e) {
      throw Exception('Failed to check college existence: $e');
    }
  }

  // Get college by ID
  Future<CollegeModel?> getCollegeById(String collegeId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('colleges').doc(collegeId).get();

      if (doc.exists) {
        return CollegeModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get college: $e');
    }
  }

  // Initialize with some sample colleges (for development/testing)
  Future<void> initializeSampleColleges() async {
    try {
      final sampleColleges = [
        // IITs
        'IIT Delhi',
        'IIT Bombay',
        'IIT Madras',
        'IIT Kanpur',
        'IIT Kharagpur',
        'IIT Roorkee',
        'IIT Guwahati',
        'IIT Hyderabad',
        'IIT Gandhinagar',
        'IIT Ropar',
        'IIT Patna',
        'IIT Jodhpur',
        'IIT Indore',
        'IIT Mandi',
        'IIT Varanasi',
        'IIT Bhubaneswar',
        'IIT Dhanbad',
        'IIT Tirupati',
        'IIT Palakkad',
        'IIT Jammu',
        'IIT Dharwad',
        'IIT Bhilai',
        'IIT Goa',

        // NITs
        'NIT Delhi',
        'NIT Mumbai',
        'NIT Chennai',
        'NIT Kolkata',
        'NIT Bangalore',
        'NIT Hyderabad',
        'NIT Warangal',
        'NIT Surathkal',
        'NIT Trichy',
        'NIT Rourkela',
        'NIT Calicut',
        'NIT Durgapur',
        'NIT Silchar',
        'NIT Hamirpur',
        'NIT Jalandhar',
        'NIT Kurukshetra',
        'NIT Patna',
        'NIT Raipur',
        'NIT Agartala',
        'NIT Srinagar',
        'NIT Meghalaya',
        'NIT Manipur',
        'NIT Mizoram',
        'NIT Nagaland',
        'NIT Puducherry',
        'NIT Sikkim',
        'NIT Uttarakhand',
        'NIT Arunachal Pradesh',
        'NIT Tripura',
        'NIT Goa',
        'NIT Lakshadweep',
        'NIT Andaman and Nicobar',
        'NIT Dadra and Nagar Haveli',
        'NIT Daman and Diu',
        'NIT Chandigarh',

        // BITS
        'BITS Pilani',
        'BITS Goa',
        'BITS Hyderabad',
        'BITS Dubai',

        // Other Premier Institutes
        'Delhi University',
        'Delhi Technological University',
        'Delhi College of Engineering',
        'Jawaharlal Nehru University',
        'Jamia Millia Islamia',
        'Aligarh Muslim University',
        'Banaras Hindu University',
        'University of Hyderabad',
        'Punjab University',
        'Mumbai University',
        'Calcutta University',
        'Madras University',
        'Bangalore University',
        'Osmania University',
        'Andhra University',
        'Karnataka University',
        'Gujarat University',
        'Rajasthan University',
        'Madhya Pradesh University',
        'Uttar Pradesh University',
        'Bihar University',
        'Assam University',
        'Manipur University',
        'Mizoram University',
        'Nagaland University',
        'Tripura University',
        'Sikkim University',
        'Arunachal Pradesh University',
        'Goa University',
        'Puducherry University',
        'Chandigarh University',
        'Delhi Public School',
        'Delhi Institute of Technology',
        'Banasthali Vidyapith',
        'Birla Institute of Technology',
        'Bharati Vidyapeeth University',
        'BMS College of Engineering',
        'BMS Institute of Technology',
        'BMS College for Women',
        'St. Xavier\'s College',
        'Loyola College',
        'Christ University',
        'St. Joseph\'s College',
        'St. Stephen\'s College',
        'Hindu College',
        'Ramjas College',
        'Miranda House',
        'Lady Shri Ram College',
        'Gargi College',
        'Kamala Nehru College',
        'Indraprastha College',
        'Daulat Ram College',
        'Maitreyi College',
        'Shri Ram College of Commerce',
        'Hansraj College',
        'Kirori Mal College',
        'Acharya Narendra Dev College',
        'Bhaskaracharya College',
        'Deen Dayal Upadhyaya College',
        'Deshbandhu College',
        'Dyal Singh College',
        'Gandhi Memorial National College',
        'Guru Gobind Singh College',
        'Keshav Mahavidyalaya',
        'Maharaja Agrasen College',
        'Maharishi Valmiki College',
        'Motilal Nehru College',
        'P.G.D.A.V. College',
        'Rajdhani College',
        'Ramanujan College',
        'Satyawati College',
        'Shahid Bhagat Singh College',
        'Shivaji College',
        'Shyam Lal College',
        'Sri Aurobindo College',
        'Sri Guru Nanak Dev Khalsa College',
        'Sri Guru Tegh Bahadur Khalsa College',
        'Swami Shraddhanand College',
        'Vivekananda College',
        'Zakir Husain College',
        'Zakir Husain Delhi College',
      ];

      // Check if colleges already exist
      final existingColleges = await getAllApprovedColleges();
      if (existingColleges.isNotEmpty) {
        return; // Already initialized
      }

      // Add sample colleges
      for (String collegeName in sampleColleges) {
        final college = CollegeModel(
          id: '',
          name: collegeName,
          isApproved: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore.collection('colleges').add(college.toMap());
      }
    } catch (e) {
      throw Exception('Failed to initialize sample colleges: $e');
    }
  }
}
