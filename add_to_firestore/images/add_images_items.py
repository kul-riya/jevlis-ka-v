from firebase_admin import credentials, initialize_app, storage

# storagekey.json downloaded from console.google > firebase-adminsdk>add new key
cred = credentials.Certificate('/home/kul-riya/Developer/Flutter/jevlis_ka/add_to_firestore/images/storagekey.json')
initialize_app(cred, {'storageBucket': 'jevlis-ka-part2.appspot.com'})

bucket = storage.bucket()
for i in range(49):
    fileName = f'menuItems/item_{i+1}.jpg'
    bucket.blob(fileName).upload_from_filename(fileName)
