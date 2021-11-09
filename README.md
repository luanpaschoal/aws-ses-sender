The "ses-email-sender.sh" script can send an email with attachment by using Amazon SES services (Amazon Simple E-mail Services). It needs the AWS cli tool.

### Install

You have to install the AWS CLI tool.
There are many ways to install the Amazon Web Service Command Line Client (aka AWS cli) (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

As a Linux user:
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

After installing AWS cli, you must configure the credential file. You can use this command:

```
aws configure
```

Copy the ses-email-sender.sh file to your desired directory and make the script executable:

```
chmod +x ses-email-sender.sh
```

### Usage

You can get help with -h or --help argument. The script will error if you don't supply any arguments.

```
$ ./ses-sender-email.sh -h

Usage: ses-email-sender.sh [-h|--help ]
        [-s|--subject <string> subject/title for email ]
        [-f|--from <email> ]
        [-r|--receiver|--receivers <emails> coma seperated emails ]
        [-b|--body <string> ]
        [-a|--attachment <filename> filepath ]
```

### Example

```
./ses-email-sender.sh -s "Relatório de Verificações XYZ" -f from@email.com.br -r receiver@email.com.br,receiver2@email.com -b "Segue em anexo relatório processado hoje." -a ./test.pdf
```
