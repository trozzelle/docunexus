import json
from fuzzywuzzy import fuzz, process

def get_fuzzy(parameters):    

    response = {}
    response['parameters'] = parameters
    response['ratio'] = fuzz.ratio(parameters['string1'].lower(),parameters['string2'].lower())
    response['partial_ratio'] = fuzz.partial_ratio(parameters['string1'].lower(),parameters['string2'].lower())
    response['token_sort_ratio'] = fuzz.token_sort_ratio(parameters['string1'],parameters['string2'])
    response['token_set_ratio'] = fuzz.token_set_ratio(parameters['string1'],parameters['string2'])
    
    return json.dumps(response)
