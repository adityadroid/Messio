final mockConversations = [Map<String, dynamic>.from({
  'latestMessage': {
    'senderName': 'Aditya Gurjar',
    'senderUsername': 'adityagurjar',
    'text': 'how yoj doin mate',
    'timeStamp': 1570389767273,
    'type': 0
  },
  'members': ['adityagurjar', 'steve'],
  'membersData': [
    {
      'age': 19,
      'chats': {'adi': 'UdDNYyYTCfy4U5pvezm7', 'roger': 'J9fzZXLzlEb4XH2GzbVL'},
      'contacts': ['adi', 'roger', 'steve'],
      'email': 'fkazsd11@gmail.com',
      'name': 'Aditya Gurjar',
      'photoUrl':
          'https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/profile_pictures%2F1569860966969_scaled_Screenshot_20190930_212128.jpg?alt=media&token=3be12c6c-d99b-4389-8036-29f0c4f8c40c',
      'uid': 'u0RVRs3hewX0Z0cqMVqzWkbxlLI3',
      'username': 'adityagurjar',
    },
    {
      'chats': {'adityagurjar': 'woIAej3BLkRnjIWVwPnz'},
      'contacts': ['adityagurjar'],
      'name': 'Steve Buck',
      'photoUrl':
          'https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/profile_pictures%2Fperson_2.jpg?alt=media&token=6750e9a4-c495-4bd3-aba4-66defa996ed6',
      'username': 'steve'
    }
  ]
}), Map<String, dynamic>.from({
  'latestMessage': {
    'senderName': 'Roger',
    'senderUsername': 'roger',
    'text': 'okay',
    'timeStamp': 1570389767273,
    'type': 0
  },
  'members': ['adityagurjar', 'roger'],
  'membersData': [
    {
      'age': 19,
      'chats': {'adi': 'UdDNYyYTCfy4U5pvezm7', 'roger': 'J9fzZXLzlEb4XH2GzbVL'},
      'contacts': ['adi', 'roger', 'steve'],
      'email': 'fkazsd11@gmail.com',
      'name': 'Aditya Gurjar',
      'photoUrl':
          'https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/profile_pictures%2F1569860966969_scaled_Screenshot_20190930_212128.jpg?alt=media&token=3be12c6c-d99b-4389-8036-29f0c4f8c40c',
      'uid': 'u0RVRs3hewX0Z0cqMVqzWkbxlLI3',
      'username': 'adityagurjar',
    },
    {
      'chats': {'adityagurjar': 'randomchatid'},
      'contacts': ['adityagurjar'],
      'name': 'Roger',
      'photoUrl':
          'https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/profile_pictures%2Fperson_2.jpg?alt=media&token=6750e9a4-c495-4bd3-aba4-66defa996ed6',
      'username': 'roger'
    }
  ]
})];

final userDataMock = Map<String, dynamic>.from({
  'age': 19,
  'chats': {
    'adi': 'UdDNYyYTCfy4U5pvezm7',
    'farazkhan': 'H9N8UyzfKaZ5DAJADYpj',
    'james': 'EuJ5YindeZ5hwKWfJsFB',
    'mattmelvin50': 'IGEX5LeREWr0G0hDYbvQ',
    'roger': 'J9fzZXLzlEb4XH2GzbVL',
    'steve': '6vnniuXY8gNJmTdu2N5Z',
    'taylor': 'L7eSSkpymyHvKDWpGa9N',
  },
  'contacts': [
    'adi',
    'roger',
    'steve',
    'farazkhan',
    'taylor',
    'mattmelvin50',
    'james'
  ],
  'email': 'fkazsd11@gmail.com',
  'name': 'Aditya Gurjar',
  'photoUrl':
      'https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/profile_pictures%2F1570368659777_scaled_Screenshot_20191003_221325.jpg?alt=media&token=48c99dd2-23cc-4a4a-879e-c003fd0ba43d',
  'uid': 'u0RVRs3hewX0Z0cqMVqzWkbxlLI3',
  'username': 'adityagurjar'
});

final messageDataMock = [
  Map<String, dynamic>.from({
    'documentId':'doc1',
  'text': "Hey",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 0,
  }),
  Map<String, dynamic>.from({
  'documentId':'doc2',
  'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 1,
    'imageUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
  'documentId':'doc3',
  'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 2,
    'videoUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc4',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 3,
    'fileUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc5',
    'text': "Hey",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 0,
  }),
  Map<String, dynamic>.from({
    'documentId':'doc6',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 1,
    'imageUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc7',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 2,
    'videoUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc8',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 3,
    'fileUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc9',
    'text': "Hey",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 0,
  }),
  Map<String, dynamic>.from({
    'documentId':'doc10',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 1,
    'imageUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc11',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 2,
    'videoUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc12',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 3,
    'fileUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc13',
    'text': "Hey",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 0,
  }),
  Map<String, dynamic>.from({
    'documentId':'doc14',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 1,
    'imageUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc15',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 2,
    'videoUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc16',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 3,
    'fileUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc17',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 3,
    'fileUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc18',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 3,
    'fileUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc19',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 3,
    'fileUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc20',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 3,
    'fileUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc21',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 3,
    'fileUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc22',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 3,
    'fileUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
  Map<String, dynamic>.from({
    'documentId':'doc23',
    'fileName': "2019_09_27_21_05_06.mp4",
    'senderName': "Aditya Gurjar",
    'senderUsername': "adityagurjar",
    'timeStamp': 1569861362935,
    'type': 3,
    'fileUrl': "https://firebasestorage.googleapis.com/v0/b/flutter-messio.appspot.com/o/videos%2F1569861356511_2019_09_27_21_05_06.mp4?alt=media&token=cd760e30-1852-418e-a6d9-a83248db109d"
  }),
];