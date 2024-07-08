from firebase_admin import credentials, initialize_app, firestore
import csv

cred = credentials.Certificate('/home/kul-riya/Developer/Flutter/jevlis_ka/add_to_firestore/images/storagekey.json')
initialize_app(cred)

db = firestore.client()

with open('menu_items.csv', 'r') as file:
    reader = csv.reader(file)
    for line in reader:
        item = {'canteenId':line[0], 'category':line[1], 'isHidden':bool(line[2]), 'isVeg':bool(line[3]), 'name':line[4], 'price':int(line[5]), 'imagePath':line[6]}
        db.collection('MenuItems').add(item)

