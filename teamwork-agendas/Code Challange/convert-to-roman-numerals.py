
# convert the given number to the roman numerals
def convert(decimal_num):
    # set the dictionary for roman numerals
    roman = {1000: 'M', 900: 'CM', 500: 'D', 400: 'CD', 100: 'C', 90: 'XC',
             50: 'L', 40: 'XL', 10: 'X', 9: 'IX', 5: 'V', 4: 'IV', 1: 'I'}
    # initialize the result variable
    num_to_roman = ''
    # loop the roman numerals, calculate for each symbol and add to the result
    for i in roman.keys():
        num_to_roman += roman[i] * (decimal_num // i)
        decimal_num %= i
    return num_to_roman

# flag to show warning to the user, default is False.
is_invalid = False

# start endless loop to get user input continuously
while True:
    # info text to be shown to the user
    info = """
###  This program converts decimal numbers to Roman Numerals ###
(To exit the program, please type "exit")
Please enter a number between 1 and 3999, inclusively : """

    # get the user input after showing info text.
    # if is_invalid set to True then show additional warning to the user
    # pass the input the alphanum variable after stripping white space characters
    alphanum = input('\nNot Valid Input !!!\n'*is_invalid + info).strip()
    # if the input is not decimal number
    if not alphanum.isdecimal():
        # then check, if it is the "exit" keyword
        if alphanum.lower() == 'exit':
            # if it is "exit", then say goodbye and terminate the program
            print('\nExiting the program... Good Bye')
            break
        # if it is a strint other than "exit"
        else:
            # then set to invalid flag to True to show warning and continue with next cycle
            is_invalid = True
            continue
    # convert the given string to the integer
    number = int(alphanum)
    # if the number is between 1 and 3999, inclusively
    if 0 < number < 4000:
        # then convert to roman numerals and print out the user
        print(
            f'\nRoman numerals representation of decimal number "{alphanum}"" is equal to {convert(number)}')
        # and set invalid flag to the False, it might be set the True in previous cycle
        is_invalid = False
    # if the number is out of bounds
    else:
        # then set to invalid flag to True to show warning
        is_invalid = True
