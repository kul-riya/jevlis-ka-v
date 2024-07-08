import csv


with open('/home/kul-riya/Developer/Flutter/jevlis_ka/add_to_firestore/menu_items.csv', 'r') as file:
    reader = csv.reader(file)
    data = list(reader)
    

for i in range(50):
    data[i].append(f'"gs://jevlis-ka-part2.appspot.com/menuItems/item_{i}.jpg"')

with open('/home/kul-riya/Developer/Flutter/jevlis_ka/add_to_firestore/menu_items_2.csv', 'w') as file:
    writer = csv.writer(file)
    writer.writerows(data)

