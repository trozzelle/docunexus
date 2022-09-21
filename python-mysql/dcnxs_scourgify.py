import re, sys, glob, usaddress, json
from scourgify import normalize_address_record
from collections import OrderedDict 

def scourgify_address(parameters):
    cant_parse = 0
    addr = parameters['address']
    addr = addr.upper().replace(',',' ').replace('  ',' ').replace('P.O. BOX','PO BOX')
    normalize_address_record_result = {}
    parsed = {}
    parsed2 = {}
    try:
        normalize_address_record_result = normalize_address_record(addr)   
        result =  normalize_address_record_result
    except:    
        result = {
            'address_line_1' : '',
            'address_line_2' : '',
            'city' : '',
            'postal_code' : '',
            'state' : '',
        }    
        has_po_box_type = 0
        has_po_box_id = 0
        has_address_number = 0
        has_oid = 0
        try:
            parsed = dict(usaddress.parse(addr))
            for key, value in parsed.items():
                if value == 'USPSBoxType':
                    result['address_line_1'] = (result['address_line_1'] + ' ' + key).strip()
                    has_po_box_type = 1
                if value == 'USPSBoxID':
                    result['address_line_1'] = (result['address_line_1'] + ' ' + key).strip()
                    has_po_box_id = 1
                if value == 'PlaceName':
                    result['city'] = (result['city'] + ' ' + key).strip()
                if value == 'StateName':
                    result['state'] = (result['state'] + ' ' + key).strip()
                if value == 'ZipCode':
                    result['postal_code'] = (result['postal_code'] + ' ' + key).strip()
                if value == 'AddressNumber':
                    has_address_number = 1
                if value == 'OccupancyIdentifier':
                    has_oid = 1
                    
            if has_po_box_type == 1 and has_po_box_id == 0 and has_address_number == 1:
                for key, value in dict(usaddress.parse(addr)).items():
                    if value == 'AddressNumber':
                        result['address_line_1'] = (result['address_line_1'] + ' ' + key).strip()
            elif has_po_box_type == 1 and has_po_box_id == 0 and has_oid == 1:
                for key, value in dict(usaddress.parse(addr)).items():
                    if value == 'OccupancyIdentifier':
                        result['address_line_1'] = (result['address_line_1'] + ' ' + key).strip()
            elif has_po_box_type == 1 and has_po_box_id == 0:
                try:
                    parsed2 = dict(usaddress.tag(address, tag_mapping={
                        'Recipient': 'recipient',
                        'AddressNumber': 'address1',
                        'AddressNumberPrefix': 'address1',
                        'AddressNumberSuffix': 'address1',
                        'StreetName': 'address1',
                        'StreetNamePreDirectional': 'address1',
                        'StreetNamePreModifier': 'address1',
                        'StreetNamePreType': 'address1',
                        'StreetNamePostDirectional': 'address1',
                        'StreetNamePostModifier': 'address1',
                        'StreetNamePostType': 'address1',
                        'CornerOf': 'address1',
                        'IntersectionSeparator': 'address1',
                        'LandmarkName': 'address1',
                        'USPSBoxGroupID': 'address1',
                        'USPSBoxGroupType': 'address1',
                        'USPSBoxID': 'address1',
                        'USPSBoxType': 'address1',
                        'BuildingName': 'address2',
                        'OccupancyType': 'address2',
                        'OccupancyIdentifier': 'address2',
                        'SubaddressIdentifier': 'address2',
                        'SubaddressType': 'address2',
                        'PlaceName': 'city',
                        'StateName': 'state',
                        'ZipCode': 'zip_code',
                        }))
                    for key, value in parsed2.items():
                        result[value] = key.strip()
                except:  
                    cant_parse = 1
        except:  
            cant_parse = 1

    if result['address_line_1'] is None:
        result['address_line_1'] = ''   
    if result['address_line_2'] is None:
        result['address_line_2'] = ''   
    if result['city'] is None:
        result['city'] = ''   
    if result['state'] is None:
        result['state'] = ''    
    if result['postal_code'] is None:
        result['postal_code'] = ''         
    
    result['postal_code'] = result['postal_code'][:5]

    if result['address_line_1'] == '' and result['address_line_2'] == '' and result['city'] == '' and result['state']  == '' and result['postal_code']  == '':
        result = {}
        address = addr
        cant_parse == 1
    elif result['address_line_1'] == '' and result['address_line_2'] == '':
        result = {}
        address = addr
        cant_parse == 1
    elif result['city'] == '' and result['state']  == '' and result['postal_code']  == '':
        result = {}
        address = addr
        cant_parse == 1
    else:
        address = ((((str(result['address_line_1']) + ' ' + str(result['address_line_2'])).strip() + ' ' + str(result['city'])).strip() + ' ' + str(result['state'])).strip() + ' ' + str(result['postal_code'])).strip()

    preferred_mapping = {
    'Recipient': 'recipient',
    'AddressNumber': 'residence_num',
    'AddressNumberPrefix': 'residence_num',
    'AddressNumberSuffix': 'residence_halfnum',
    'StreetName': 'residence_street_name',
    'StreetNamePreDirectional': 'residence_pre_street_dir',
    'StreetNamePreModifier': 'residence_street_name',
    'StreetNamePreType': 'residence_street_name',
    'StreetNamePostDirectional': 'residence_post_street_dir',
    'StreetNamePostModifier': 'residence_post_street_dir',
    'StreetNamePostType': 'residence_street_name',
    'CornerOf': 'residence_street_name',
    'IntersectionSeparator': 'residence_street_name',
    'LandmarkName': 'residence_street_name',
    'USPSBoxGroupID': 'residence_street_name',
    'USPSBoxGroupType': 'residence_street_name',
    'USPSBoxID': 'residence_street_name',
    'USPSBoxType': 'residence_street_name',
    'BuildingName': 'residence_street_name',    
    'OccupancyType': 'occupancy_type',
    'OccupancyIdentifier': 'residence_aptnum',
    'SubaddressIdentifier': 'residence_street_name',
    'SubaddressType': 'residence_street_name',
    'PlaceName': 'city',
    'StateName': 'state',
    'ZipCode': 'zip'
    }    
    try:
        # initialize
        parsed_address = {}    
        for key, value in preferred_mapping.items():
            parsed_address[str(value)] = ''
        # parse, flip, concat    
        parsed_address_test = dict(usaddress.parse(address))
        for key, value in preferred_mapping.items():
            for key2, value2 in parsed_address_test.items():
                if str(value2) == str(key):
                    parsed_address[str(value)] = (parsed_address[str(value)] + ' ' + str(key2)).strip()
    except:  
        parsed_address = {}   
        parsed_address_test = {} 

    return json.dumps({'address':address,'parsed_address':parsed_address})


def scourgify_file(parameters):
    fout = open(parameters['output'], "w")
    for line in open(parameters['input'], 'r'):
        split_line = line.split("\t")
        nys_voter_id = split_line[0].strip()
        address = scourgify_address({'address':split_line[1].strip()})
        #print(nys_voter_id + "\t" + address)
        fout.write(nys_voter_id + "\t" + address)
    fout.close()
