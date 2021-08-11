The "sender.sh" script can send an email with attachment by using Amazon SES services (Amazon Simple E-mail Services). It needs the AWS cli tool.

### Install

You have to install the AWS CLI tool.
There are many ways to install the Amazon Web Service Command Line Client (aka AWS cli) (http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
As a Mac user, I prefer to use Homebrew (https://brew.sh/)

```
brew install awscli
```

After installing AWS cli, you must configure the credential file. You can use this command:

```
aws configure
```

Copy the sender.sh file to your desired directory and make the script executable:

```
chmod +x sender.sh
```

### Usage

You can get help with -h or --help argument. The script will error if you don't supply any arguments.

```
$ ./sender.sh -h

Usage: sender.sh [-h|--help ]
        [-s|--subject <string> subject/title for email ]
        [-f|--from <email> ]
        [-r|--receiver|--receivers <emails> coma seperated emails ]
        [-b|--body <string> ]
        [-a|--attachment <filename> filepath ]
```

### Example

```
./sender.sh -s test -f ambanmba@fakeaddress.net -r ambanmba@notmyrealmail.com -b "mail content" -a ~/Documents/Image_00001.jpg
```
