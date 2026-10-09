import json
from wonderwords import RandomWord,Defaults

if __name__ == "__main__":
    data = {
        "random_name": "{}-{}".format(RandomWord(adjective=Defaults.ADJECTIVES).word(), RandomWord(noun=Defaults.NOUNS).word())
    }
    
    print(json.dumps(data))
    