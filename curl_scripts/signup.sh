#!/bin/bash

# usage: ./signup.sh firstname lastname email passwd username
# NOTE: the '@' in the email address will be replaced with '%40'

echo "Signing up for CoPatient..." >&2

firstname=$1
lastname=$2
email=$(echo "$3" | sed 's/@/%40/')
#echo "email= $email" >&2
passwd=$4
username=$5


# 'openssl' must be 1.0.1+, or some version that does SHA256
#	  note: the mac one is 9.8 and doesn't do SHA256
openssl=/opt/local/bin/openssl

access_key="630ac3f4c85b2e7c7c828ee048f7b3d9936312a3fff1a33648bfb34c146ec532"
secret_key="fd9bbb59fa527dc161b08f3df2d5e2aa6db0017447c3001420b0a4033c6e4cbe"

CP_URL="https://dev.copatient.com"
signup_URI="/api/account/signup"

signup_request=$signup_URI'?access_key='$access_key'&firstname='$firstname'&lastname='$lastname'&email='$email'&password='$passwd'&confirm='$passwd'&terms=1&username='$username

echo "signup_request = $signup_request" >&2

raw_hash_value=$(echo -n $signup_request | $openssl sha256 -hmac $secret_key)
#echo "raw openssl output:  $raw_hash_value"

#  strip off the pointless '(stdin)=' field that some openssls return
hash_value=$(echo -n $raw_hash_value | awk '{print $2}') 
echo "hash_value= $hash_value" >&2

post_param='access_key='$access_key'&firstname='$firstname'&lastname='$lastname'&email='$email'&password='$passwd'&confirm='$passwd'&terms=1&username='$username'&signature='$hash_value
echo "post_param= $post_param" >&2

full_URI=$CP_URL$signup_URI
echo "full_URI= $full_URI" >&2

# take out or add '-v' depending on whether you want the details
/usr/bin/curl --data $post_param $full_URI | jsawk 'return this.return'
