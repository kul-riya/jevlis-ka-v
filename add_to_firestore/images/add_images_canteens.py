from firebase_admin import credentials, initialize_app, storage

cred = credentials.Certificate('/home/kul-riya/Developer/Flutter/jevlis_ka/add_to_firestore/images/storagekey.json')
initialize_app(cred, {'storageBucket': 'jevlis-ka-part2.appspot.com'})

fileName = 'canteens/bcc.jpeg'
storage.bucket().blob(fileName).upload_from_filename(fileName)
