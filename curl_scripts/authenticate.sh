#!/bin/bash

echo "Authenticating CoPatient user..."

# 'openssl' must be 1.0.1+, or some version that does SHA256
#	  note: the mac one is 9.8 and doesn't do SHA256
openssl=/opt/local/bin/openssl

user="demouser"
password="password1"

access_key="630ac3f4c85b2e7c7c828ee048f7b3d9936312a3fff1a33648bfb34c146ec532"
secret_key="fd9bbb59fa527dc161b08f3df2d5e2aa6db0017447c3001420b0a4033c6e4cbe"

CP_URL="https://dev.copatient.com"
authent_URI="/api/account/authenticate"

auth_request=$authent_URI'?access_key='$access_key'&username='$user'&password='$password
#echo "auth_request = $auth_request"

raw_hash_value=$(echo -n $auth_request | $openssl sha256 -hmac $secret_key)
#echo "raw openssl output:  $raw_hash_value"

#  strip off the pointless '(stdin)=' field that some openssls return
hash_value=$(echo -n $raw_hash_value | awk '{print $2}') 
# echo "hash_value= $hash_value"

post_param='access_key='$access_key'&username='$user'&password='$password'&signature='$hash_value
#echo "post_param= $post_param"

full_URI=$CP_URL$authent_URI
#echo "full_URI= $full_URI"

# take out or add '-v' depending on whether you want the details
/usr/bin/curl --data $post_param $full_URI 
