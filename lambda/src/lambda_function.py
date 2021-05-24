def lambda_handler(event, context):
    request = event['Records'][0]['cf']['request']
    headers = request['headers']
    
    APAC_REGION = ["SG", "TH", "MY", "VN", "RI", "KH", "MM"]
    US_REGION = ["US"]
    
    url = 'https://happay.com'
    
    viewerCountry = headers.get('cloudfront-viewer-country')
    if viewerCountry:
        countryCode = viewerCountry[0]['value']
        if countryCode in US_REGION and request['uri'] == '/index.html':
            url = url + '/us/'
        else:
            return request

    response = {
        'status': '302',
        'statusDescription': 'Found',
        'headers': {
            'location': [{
                'key': 'Location',
                'value': url
            }]
        }
    }

    return response