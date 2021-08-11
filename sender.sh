#!/bin/bash

# Created on 2019.08.10
# Aim: Send email with attachment from AWS SES
# Coder : baturorkun@hmail.com / Batur Orkun

# Modifications by Alastair Bor
# Removed setting aws region/id/key which can be done separately
# Rewritten to allow for larger attachments (AWS limit is 10MB)
# Removed the need to have a separate template file
# Added automatic determination of correct MIME Type for attachment

function usage() {
    echo "Usage: $0 [-h|--help ]
        [-s|--subject <string> subject/title for email ]
        [-f|--from <email> ]
        [-r|--receiver|--receivers <emails> coma seperated emails ]
        [-b|--body <string> ]
        [-a|--attachment <filename> filepath ]
        " 1>&2;
    exit 1;
}

function Error() {
    echo "Error: $1"
    exit
}

function checkRequirements() {

    which  aws
    if [ $? -ne 0 ]; then
        Error "AWS cli tool is installed"
    fi

    which  base64
    if [ $? -ne 0 ]; then
        Error "base64 tool is installed"
    fi
}

function sendMail() {
    PARTA="{\"Data\": \"From: {FROM}\nTo: {RECVS}\nSubject: {SUBJECT}\nMIME-Version: 1.0\nContent-type: Multipart/Mixed; boundary=\\\"NextPart\\\"\\n\\n--NextPart\\nContent-Type: text/plain\\nContent-Transfer-Encoding: base64\\n\\n{BODY}\\n\\n--NextPart\\nContent-Type: {MIMETYPE};\\nContent-Disposition: attachment; filename=\\\"{FILENAME}\\\"\\nContent-Transfer-Encoding: base64\\n\\n"
    PARTB="\\n\\n--NextPart--\"}"

    if [[ -z ${ATTACHMENT} ]]; then
        ATTACHMENT=$BODY
        FILENAME="Message.txt"
        MIMETYPE="text/plain"
    else
        FILENAME=$(basename "${ATTACHMENT%}")
        MIMETYPE=`file --mime-type $ATTACHMENT | sed 's/.*: //'`
        ATTACHMENT=`base64 -e $ATTACHMENT`
    fi

    TMPFILE="/tmp/ses-$(date +%s)"
	
	printf "%s" $PARTA > $TMPFILE
    printf "%s" $ATTACHMENT >> $TMPFILE
    printf "%s" $PARTB >> $TMPFILE

    sed -i '' -e "s/{SUBJECT}/$SUBJECT/g" $TMPFILE
    sed -i '' -e "s/{FROM}/$FROM/g" $TMPFILE
    sed -i '' -e "s/{RECVS}/$RECVS/g" $TMPFILE
    sed -i '' -e "s/{BODY}/$BODY/g" $TMPFILE
    sed -i '' -e "s/{FILENAME}/$FILENAME/g" $TMPFILE
    sed -i '' -e "s!{MIMETYPE}!$MIMETYPE!g" $TMPFILE  #Use ! as delimiter because MIMETYPE has /
    sed -i '' -e "s/$(printf '\r')//g" $TMPFILE       #Remove extraneous \r characters
 
    aws ses send-raw-email --cli-binary-format raw-in-base64-out --raw-message file://$TMPFILE
}

while :; do
  case $1 in
    -h|-\?|--help)
        usage
        ;;
    -s|--subject)
        SUBJECT=$2
        shift
        ;;
    -f|--from)
        FROM=$2
        shift
        ;;
    -r|--receiver|--receivers)
        RECVS=$2
        shift
        ;;
    -b|--body)
        BODY=`echo "$2" | base64`
        shift
        ;;
    -a|--attachment)
        ATTACHMENT=$2
        shift
        ;;
    *)  # Default case: No more options, so break out of the loop.
        break
  esac

  shift
done

checkRequirements

sendMail
