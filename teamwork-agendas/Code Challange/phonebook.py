phonebook = {}

def find(keyword):
    return phonebook.get(keyword, f"Couldn't find phone number of {keyword}")

def add(name, phone_number):
    phonebook[name] = phone_number
    return f'Phone number of {name} is inserted into the phonebook'

def delete(name):
    try:
        phonebook.pop(name)
    except KeyError as err:
        return f'{err} is not in the phonebook'
    else:
        return f'{name} is deleted from the phonebook'

if __name__ == '__main__':
    print('Welcome to the phonebook application')
    print('1. Find phone number')
    print('2. Insert a phone number')
    print('3. Delete a person from the phonebook')
    print('4. Terminate')
    no = input('Select operation on Phonebook App (1/2/3) : ')
    while True:
        if no == '1':
            name = input('Find the phone number of : ')
            print(find(name))
            print(" ")
        elif no == '2':
            name = input('Insert name of the person : ')
            try:
                number = int(input('Insert phone number of the person: '))
            except ValueError as err:
                print('Invalid input format, cancelling operation ...')
            else:
                print(add(name, number))
            print(" ")
        elif no == '3':
            name = input('Whom to delete from phonebook : ')
            print(delete(name))
            print(" ")
        elif no == '4':
            print('Exiting Phonebook')
            break
        else:
            print('Wrong operation')

        print('1. Find phone number')
        print('2. Insert a phone number')
        print('3. Delete a person from the phonebook')
        print('4. Terminate')
        no = input('Select operation on Phonebook App (1/2/3) : ')