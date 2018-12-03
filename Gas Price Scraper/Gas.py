from urllib.request import urlopen as uReq
from bs4 import BeautifulSoup as soup

#gets zip code to use in URL to scare from
zipcode = input("Please enter your zip: ")
num_check = len(zipcode)

#validates input
while(num_check != 5 or not zipcode.isnumeric()):
    print('Must be a 5 digit number.')
    zipcode = input("Please enter your zip: ")
    num_check = len(zipcode)


#check to see if you want cheapest or closest
select = input("Do you want cheapest gas stations(1)? or closest gas stations(2)?: ")
#validates input
while(not select.isnumeric() and select != 1 and select != 2):
    print('Must be a 1 or 2')
    select = input("Do you want cheapest gas stations(1)? or closest gas stations(2)?: ")

#sets url
if(int(select) == 1):
    my_url = 'https://www.autoblog.com/' + zipcode + '-gas-prices/sort-price/'
    #checks to see if you want 10 or 1
    check = input("Do you want 10 cheapest gas stations(1)? or 1 cheapest price(2)?: ")
    #validates input
    while(not check.isnumeric() and check != 1 and check != 2):
        print('Must be a 1 or 2')
        check = input("Do you want 10 cheapest gas stations(1)? or 1 cheapest price(2)?: ")

if(int(select) == 2):
    my_url = 'https://www.autoblog.com/' + zipcode + '-gas-prices/'
    #checks to see if you want 10 or 1
    check = input("Do you want 10 closest gas stations(1)? or 1 closest price(2)?: ")
    #validates input
    while(not check.isnumeric() and check != 1 and check != 2):
        print('Must be a 1 or 2')
        check = input("Do you want 10 closest gas stations(1)? or 1 closest price(2)?: ")



#opens connection and grabs html from page
uClient = uReq(my_url)

#stores content into a variable so we dont lose it
page_html = uClient.read()

#close page
uClient.close()

#Beautiful soup goodness...html parsing
page_soup = soup(page_html, "html.parser")

#grabs each station and price:
stations = page_soup.findAll("li", {"class":"shop"})
prices = page_soup.findAll("li", {"class":"price"})

print('================================================')
if(int(check) == 2):
    if(int(select) == 1):
        print('Hello! Welcome to the Cheapest Gas Price Finder!')
    if(int(select) == 2):
        print('Hello! Welcome to the Closest Gas Price Finder!')
if(int(check) == 1):
    if(int(select) == 1):
        print('Hello! Welcome to the 10 Cheapest Gas Price Finder!')
    if(int(select) == 2):
        print('Hello! Welcome to the 10 Closest Gas Price Finder!')
print('================================================')
print(f'\nZip Code  :        {zipcode}')

#function to print list
def printlist():
    print(f'Name      :        {name}')
    print(f'Address   :        {address}')
    print(f'Price     :        {low_price}')
    print(f'Distance  :        {distance}')

#of shops:
num_shops = len(stations)

if(int(check) == 2):
    #Closest/Cheapest price is stations[0]
    cheapest = stations[0]
    cheapprice = prices[0]
    name = cheapest.h4.text
    distance = cheapest.data.text
    address = cheapest.address.text
    low_price = cheapprice.data.text
    printlist()

if(int(check) == 1):
    for x in range(0,num_shops):
        cheapest = stations[x]
        cheapprice = prices[x]
        name = cheapest.h4.text
        distance = cheapest.data.text
        address = cheapest.address.text
        low_price = cheapprice.data.text
        print(f'\n---=[ {x+1} ]=---\n')
        printlist()    


print('================================================')

