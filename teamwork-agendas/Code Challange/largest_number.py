num_list = list(num for num in input("Enter five numbers separated by space ").strip().split())


if len(num_list) < 5:
    print ("You should enter", 5-len(num_list), "more number(s)")

elif len(num_list) > 5:
    print ("You entered", len(num_list)-5, "more number(s) than 5")



elif len(num_list) == 5:
    
    for i in range (len(num_list)):
        max_num = num_list[i]
        if not num_list[i].isnumeric():
            
            print(num_list[i], " is not a number")
        #else:
            num_list[i]= float(num_list[i])
        
    
    for i in range (len(num_list)):    
        
        if num_list[i] > max_num:
            max_num = num_list[i]
    print(max_num)
  
        
        
    
