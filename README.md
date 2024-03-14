# OPENVPN-ON-AWS
This project is for building up a VPN personally on AWS. Guys in mainland China could access it to browse websites. I live in AU but I want to use google when in china, This is reason why i want to build up the proj。


## Deploy EC2 instance and init openvpn through CloudFormation

Files in [Ias-aws](./Ias-aws/) could let you deploy the EC2 instance with openvpn AMI automatically. 

```tree
.
├── Ias-aws
│   ├── ec2-openvpn-ami.yml
│   ├── instance-initilisation.sh
```
[ec2-openvpn-ami.yml](./Ias-aws/ec2-openvpn-ami.yml) is the cfn file. You only need to provide the parameter `VpcId` a value, and you could drop this file through AWS console and run it. services including EC2, Elastic IP, Security group would be deployed automatically. 

You could change other parameter values if you want. 

If you do not choose ap-southeast-1 or ap-southeast-2, you could search the corresponding AMI ID through AWS marketplace of openvpn and add it in the cfn file. The stack would retrieve automatically.

[instance-initilisation.sh](./Ias-aws/instance-initilisation.sh) includes all interactive prompts when you initialise the openvpn server, you need you privde the correspodning Elastic IP (in format 0-0-0-0) to `EIP_ADDRESS` and give your own password to `OPENVPN_PASSWORD`. 

run in terminal:
```bash
cd Ias-aws
./instance-initilisation.sh
```

You would get two urls at the end:

```
https://{ Elastic IP }:{ ADMIN_PORT }/admin
```
you could setup configs through this UI

```
https://{ Elastic IP }:{ ADMIN_PORT }/
```

you need to click `profile management` button, download the openvpn config file.

### Run with github action

You also could run it through the pipeline.

1. [Add identify providers in IAM](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#adding-the-identity-provider-to-aws)

* Add `https://token.actions.githubusercontent.com` as Provider name.
* Add `sts.amazonaws.com` as Audience.

2. Create an trust web identity role in IAM

* Select your created provider name and audience.
* Add your repo name as GitHub organization, for me is `Yi-Ding111/OPENVPN-ON-AWS`
* Add permissions for EC2 and CloudFormation.
* the trust policy should look like [web-identity-role-policy.json](./Ias-aws/web-identify-role-policy.json)

3. Encrypted ec2 keypair pem file
```
base64 -i openvpn.pem -o openvpn.pem.base64
```

3. Add github action secrets and variables

* Copy Encrypted ec2 keypair value as a secret `AWS_EC2_PEM`
* Store you like password as `OPENVPN_PASSWORD` in secrets.
* Copy your role ARN and as a secret `ROLE_TO_ASSUME`.
* Choose your VPC id (I use the default) as the secert `VPC_ID`.
* Add aws region as `AWS_REGION` in environment variable.

The you could run the pipeline and deploy all stuff automatically.

