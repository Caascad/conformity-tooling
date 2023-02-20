import requests

url = 'https://api.quotable.io/random'
def main():
    r = requests.get(url)
    quote = r.json()
    #print(quote)
    print(quote['content'])
    print('     -',quote['author'])
