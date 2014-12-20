#!/bin/bash

# usage: ./upload.sh token filename description BillFile.pdf
if (( $# != 4)); then
	echo "wrong number of args: usage: ./upload.sh token filename description BillFile.pdf"
	exit
fi

echo "Uploading PDF to CoPatient..." 

auth_token=$1
filename=$2
description=$3
orig_pdf_file=$4
# temp file storing encoded pdf
encoded_pdf_file="/tmp/CP_tmp_file"

echo "auth_token: $auth_token"

echo "base64 encoding pdf file..."
cat $orig_pdf_file | uuencode -m "base64XXencode" | sed 's/=/%3D/g' | tail -n 2 | perl -p -e 's/\n/%2B/' > $encoded_pdf_file
#exit

# 'openssl' must be 1.0.1+, or some version that does SHA256
#	  note: the mac one is 9.8 and doesn't do SHA256
openssl=/opt/local/bin/openssl

access_key="630ac3f4c85b2e7c7c828ee048f7b3d9936312a3fff1a33648bfb34c146ec532"
secret_key="fd9bbb59fa527dc161b08f3df2d5e2aa6db0017447c3001420b0a4033c6e4cbe"

CP_URL="https://dev.copatient.com"
upload_URI="/api/file/upload"
mime_type="application%2Fpdf"

upload_request=$upload_URI'?access_key='$access_key'&token='$auth_token'&filename='$filename'&mime_type='$mime_type'&contents='$(cat $encoded_pdf_file)'&story='$description

#echo "upload_request = $upload_request"
#exit

raw_hash_value=$(echo -n $upload_request | $openssl sha256 -hmac $secret_key)
#echo "raw openssl output:  $raw_hash_value"

#  strip off the pointless '(stdin)=' field that some openssls return
hash_value=$(echo -n $raw_hash_value | awk '{print $2}') 
#echo "hash_value= $hash_value"
#exit

post_param='access_key='$access_key'&token='$auth_token'&filename='$filename'&mime_type='$mime_type'&contents='$(cat $encoded_pdf_file)'&story='$description'&signature='$hash_value
echo "post_param= $post_param"
#exit

full_URI=$CP_URL$list_URI
#echo "full_URI= $full_URI"

# take out or add '-v' depending on whether you want the details
/usr/bin/curl --data $post_param $full_URI 
