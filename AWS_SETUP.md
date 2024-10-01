<h3>Set up the AWS Infrastructure</h3>

1. Log in to your AWS Management Console.
2. Navigate to the VPC dashboard and click ```Create VPC```.<br />
Name your VPC (e.g. ```MERN VPC```), and set the IPV4 CIDR to ```10.0.0.0/16```.

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXf6EQ7WPFrvfjGKgpy0p6bZT_1KEhTpDxq2eNfmrCg5OFdRm-95GTghUMCiK7bv-ShwIn1WBy3HjUEBiF9eLVE5GNs94ErBaEc2YUB62I9nA8vv6r44VZ-wKZk6GzEAPweg1RP68IIB53pvLz-i9PpFH06N?key=vWCvjAUF9WlZE2WBqzzL4Q)

3. Under the VPC dashboard, go to ```Subnets```, then click ```Create subnet```.<br />
	Select the newly created VPC (```MERN VPC```), then create the following subnets:

| Subnet name | Availability Zone | IPv4 VPC CIDR block | IPv4 subnet CIDR block |
| --- | --- | --- | --- |
| ```Public subnet``` | ```us-east-1a``` | ```10.0.0.0/16``` | ```10.0.1.0/24``` |
| ```Private subnet``` | ```us-east-1a``` | ```10.0.0.0/16``` | ```10.0.2.0/24``` |
		
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdqWbdINO3zcb6Wa9KkWL2xecvNH3EeN0UrFTtRtJp9Kb9AoPCT8CtJsZ6cGw3YMXW0lzBMtbKNo9HtTwLQp0FMfba2aW2xJVfEd5MiyW5YYYAgAaqpnMLm3acKzz0mPd8J0v9BmgwS2TtklfFYzsbmkTHu?key=vWCvjAUF9WlZE2WBqzzL4Q)

 4. Under the VPC dashboard, go back to ```Your VPCs```, then click ```MERN VPC```.<br />
	Navigate below to ```Details```, go to ```Main route table```, then click the hyperlinked ```Route table ID```.<br />
  You are now on the ```Route tables``` page.<br />
  Point your mouse cursor on the cell below the ```Name``` column, then click the pencil icon to ```Edit Name```. Set it to ```Public-RT```, then ```Save```.<br />
  Navigate to ```Subnet associations``` tab **>** ```Explicit subnet associations``` **>** ```Edit subnet associations```<br />
  Select ```Public subnet```, then ```Save associations```.<br />
  Add another route table by clicking ```Create route table```. Name it ```Private-RT```, select ```MERN VPC```, then create.<br />
  Do the same process on configuring subnet associations, but this time select ```Private subnet```.

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcosFVYPdxPyqn0qpqjhUWRUaJ643HYia-TDt-J9sg8xPt2YjKNViGuZvght0tKoTJW4gn7TfFdiG4UNMlbFtb2cJ_Cc3NSM7ZbPlGsePhAmtKskIGYWgN8BJK_Q49ZRdVpJGuhpHfAa3G95VHdbxI7UYjN?key=vWCvjAUF9WlZE2WBqzzL4Q)

5. Under the VPC dashboard, go to ```Internet gateways```, then click ```Create internet gateway```.<br /> 
Name your internet gateway (e.g. ```MERN-IG```), then create.<br />
Click on the newly created internet gateway, then ```Actions``` **>** ```Attach to VPC```.<br />
Select ```MERN VPC```, then attach.

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXesHVD432OKYBE29XkiZa7WAVzLB__CdtvpCgK6bVbGdChH3gCzG7C1DonD922w4qeemlrj1pUXpeABCyi1bZMV4fDcyO1Mi1hmpIKN3BYUsf3oQYXJbI3vDEXutX6vOToptqvMMhvXPjHZZr0unwZAi5MA?key=vWCvjAUF9WlZE2WBqzzL4Q)

6. In this step, we will configure the ```Public-RT``` route table to enable public resources to communicate outside our VPC (give internet access).<br />
Go back to ```Route tables```, then select ```Public-RT```.<br />
Go to the ```Routes``` tab **>** ```Edit routes``` **>** ```Add route```

| Destination | Target |
| --- | --- |
| ```0.0.0.0/0``` | ```Internet Gateway > MERN-IG``` |

7. For the ```Private subnet```, we also need to give internet access to private resources to be able to download/install the applications (e.g. Git, Docker), and also for future updates.<br />
	This is why we need to deploy a **NAT instance** in the ```Public subnet```. It will serve as the **NAT gateway** that will link ```Private subnet``` to the internet.<br /><br />
 
   ***To setup NAT instance:***
- Under the VPC dashboard, go to ```Security groups```, then click ```Create security group```.
     
| Security group name | Description | VPC | Inbound rules | Outbound rule |
| --- | --- | --- | --- | --- |
| ```NAT-SG``` | ```SG for NAT instance``` | ```MERN VPC``` | ```Type = HTTP```<br />```Protocol = TCP```<br />```Port range = 80```<br />```Source = Custom > 10.0.2.0/24```<br /><br />```Type = HTTP```<br />```Protocol = TCP```<br />```Port range = 443```<br />```Source = Custom > 10.0.2.0/24```<br /><br />```Type = SSH```<br />```Protocol = TCP```<br />```Port range = 22```<br />```Source = Anywhere-IPv4``` | *(default)* |

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfLGtwiNgVm25NFLTfbA-3hJ4EPHeSWq6nCLSMzQUBAzCDSUrN5Htkff6uJzduVChH_hUtGT1rBNOsrO-udi4fv7Bd2KWZ0A-iLDv8HVfBb-FMuZLxo2GsqGZf3BKIFdQdsFaBPjkCAtsd0GhzxZQ9rRICb?key=vWCvjAUF9WlZE2WBqzzL4Q)

  - Navigate to the EC2 dashboard and click ```Launch instance```.

| Name | Application and OS Image | Instance type | Key pair | Network settings |
| --- | --- | --- | --- | --- |
| ```NAT-instance``` | ```Amazon Linux 2023 AMI``` | ```t2.micro``` | *(select an existing key pair - e.g.* ```MERN.pem```*)* | ```VPC = MERN VPC```<br />```Subnet = Public subnet```<br />```Auto-assign public IP = Enable```<br />```Firewall = Select existing security group > NAT-SG``` |
  
  >```Advanced details``` **>** ```User Data``` - *copy/paste the following commands:*
```
#!/bin/bash
sudo yum install iptables-services -y
sudo systemctl enable iptables
sudo systemctl start iptables
echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/custom-ip-forwarding.conf
sudo sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf
sudo /sbin/iptables -t nat -A POSTROUTING -o enX0 -j MASQUERADE
sudo /sbin/iptables -F FORWARD
sudo service iptables save
```

  - Under the EC2 dashboard, go to ```Instances```, then select ```NAT-instance```.<br />
  Choose ```Actions``` **>** ```Networking``` **>** ```Change source/destination check```<br />
  For ```Source/destination checking```, select ```Stop```, then ```Save```.

  - The route table for the Private subnet must have a route that sends internet traffic to the NAT instance.<br />
  Go back to ```Route tables```, then select ```Private-RT```.<br />
  Go to the ```Routes``` tab **>** ```Edit routes``` **>** ```Add route```

| Destination | Target |
| --- | --- |
| ```0.0.0.0/0``` | ```Instance > NAT-instance``` |

8. Before deploying the resources, we will first configure their respective ```Security groups```.<br />
	Under the VPC dashboard, go to ```Security groups```, then click ```Create security group```.

| Security group name | Description | VPC | Inbound rules | Outbound rule |
| --- | --- | --- | --- | --- |
| ```Proxy-SG``` | ```SG for Proxy server instance``` | ```MERN VPC``` | ```Type = HTTP```<br />```Protocol = TCP```<br />```Port range = 80```<br />```Source = Anywhere-IPv4```<br /><br />```Type = HTTP```<br />```Protocol = TCP```<br />```Port range = 443```<br />```Source = Anywhere-IPv4```<br /><br />```Type = SSH```<br />```Protocol = TCP```<br />```Port range = 22```<br />```Source = Anywhere-IPv4```<br /><br />```Type = Custom TCP```<br />```Protocol = TCP```<br />```Port range = 8081```<br />```Source = Anywhere-IPv4``` | *(default)* |
| ```Frontend-SG``` | ```SG for Frontend instances``` | ```MERN VPC``` | ```Type = HTTP```<br />```Protocol = TCP```<br />```Port range = 80```<br />```Source = Custom > Proxy-SG```<br /><br />```Type = HTTP```<br />```Protocol = TCP```<br />```Port range = 443```<br />```Source = Custom > Proxy-SG```<br /><br />```Type = SSH```<br />```Protocol = TCP```<br />```Port range = 22```<br />```Source = Anywhere-IPv4```<br /><br />```Type = All ICMP - IPv4```<br />```Protocol = ICMP```<br />```Port range = All```<br />```Source = Custom > Frontend-SG``` | *(default)* |
| ```Public NLB-SG``` | ```SG for Public NLB``` | ```MERN VPC``` | ```Type = Custom TCP```<br />```Protocol = TCP```<br />```Port range = 8081```<br />```Source = Anywhere-IPv4```<br /><br />```Type = Custom TCP```<br />```Protocol = TCP```<br />```Port range = 5000```<br />```Source = Anywhere-IPv4``` | *(default)* |
| ```Backend-SG``` | ```SG for Backend instances``` | ```MERN VPC``` | ```Type = SSH```<br />```Protocol = TCP```<br />```Port range = 22```<br />```Source = Custom > Frontend-SG```<br /><br />```Type = Custom TCP```<br />```Protocol = TCP```<br />```Port range = 5000```<br />```Source = Custom > Public NLB-SG```<br /><br />```Type = All ICMP - IPv4```<br />```Protocol = ICMP```<br />```Port range = All```<br />```Source = Custom > 10.0.2.0/24``` | *(default)* |
| ```database-SG``` | ```SG for EC2 Mongodb instance``` | ```MERN VPC``` | ```Type = SSH```<br />```Protocol = TCP```<br />```Port range = 22```<br />```Source = Custom > Frontend-SG```<br /><br />```Type = Custom TCP```<br />```Protocol = TCP```<br />```Port range = 27017```<br />```Source = Custom > Backend-SG```<br /><br />```Type = Custom TCP```<br />```Protocol = TCP```<br />```Port range = 8081```<br />```Source = Custom > Public NLB-SG```<br /><br />```Type = All ICMP - IPv4```<br />```Protocol = ICMP```<br />```Port range = All```<br />```Source = Custom > 10.0.2.0/24``` | *(default)* |  

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfdR7D_o75-4uFAGU4Zn_EUgi8nfP8v4Tk9XIyGzeQ0L6XrjY1NP6Ij1eVxfeN3XB4-60cZUK6J-mqZXw2R_5aLHTX3d1IQxblI6IuYeogz-O5PsaKGUQb3iv8p72w-GhL834szNrL5ZkNJqO6OV08Zse8v?key=vWCvjAUF9WlZE2WBqzzL4Q)

9. We will now deploy the ```EC2 instances```.<br />
	Navigate to the EC2 dashboard and click ```Launch Instance```.

| Name | Application and OS Image | Instance type | Key pair | Network settings |
| --- | --- | --- | --- | --- |
| ```EC2 Mongodb``` | ```Amazon Linux 2023 AMI``` | ```t2.micro``` | *(select an existing key pair - e.g.* ```MERN.pem```*)* | ```VPC = MERN VPC```<br />```Subnet = Private subnet```<br />```Auto-assign public IP = Disable```<br />```Firewall = Select existing security group > database-SG``` |
  
  >```Advanced details``` **>** ```User Data``` - *copy/paste the following commands:*
```
#!/bin/bash
yum update -y
yum install git -y
git config --global user.name "<YOUR_GITHUB_USERNAME>"
git config --global user.email "<YOUR_GITHUB_EMAIL>"
yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```
> [!IMPORTANT]
> Change the values for ```<YOUR_GITHUB_USERNAME>``` and ```<YOUR_GITHUB_EMAIL>```.

| Name | Application and OS Image | Instance type | Key pair | Network settings |
| --- | --- | --- | --- | --- |
| ```backend-instance-1``` | ```Amazon Linux 2023 AMI``` | ```t2.micro``` | *(select an existing key pair - e.g.* ```MERN.pem```*)* | ```VPC = MERN VPC```<br />```Subnet = Private subnet```<br />```Auto-assign public IP = Disable```<br />```Firewall = Select existing security group > Backend-SG``` |
  
  >```Advanced details``` **>** ```User Data``` - *copy/paste the following commands:*
```
#!/bin/bash
yum update -y
yum install git -y
git config --global user.name "<YOUR_GITHUB_USERNAME>"
git config --global user.email "<YOUR_GITHUB_EMAIL>"
yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
```

> [!TIP]
> Do the same setup for the 2nd and 3rd Backend instances, but name it ```backend-instance-2``` and ```backend-instance-3```, respectively.

| Name | Application and OS Image | Instance type | Key pair | Network settings |
| --- | --- | --- | --- | --- |
| ```frontend-instance-1``` | ```Amazon Linux 2023 AMI``` | ```t2.micro``` | *(select an existing key pair - e.g.* ```MERN.pem```*)* | ```VPC = MERN VPC```<br />```Subnet = Public subnet```<br />```Auto-assign public IP = Enable```<br />```Firewall = Select existing security group > Frontend-SG``` |
  
  >```Advanced details``` **>** ```User Data``` - *copy/paste the following commands:*
```
#!/bin/bash
yum update -y
yum install git -y
git config --global user.name "<YOUR_GITHUB_USERNAME>"
git config --global user.email "<YOUR_GITHUB_EMAIL>"
yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

> [!TIP]
> Do the same setup for the 2nd Frontend instance, but name it ```frontend-instance-2```.

| Name | Application and OS Image | Instance type | Key pair | Network settings |
| --- | --- | --- | --- | --- |
| ```Proxy-server``` | ```Amazon Linux 2023 AMI``` | ```t2.micro``` | *(select an existing key pair - e.g.* ```MERN.pem```*)* | ```VPC = MERN VPC```<br />```Subnet = Public subnet```<br />```Auto-assign public IP = Enable```<br />```Firewall = Select existing security group > Proxy-SG``` |
  
  >```Advanced details``` **>** ```User Data``` - *copy/paste the following commands:*
```
#!/bin/bash
yum update -y
yum install git -y
git config --global user.name "<YOUR_GITHUB_USERNAME>"
git config --global user.email "<YOUR_GITHUB_EMAIL>"
yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
```

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXemFZe5RxaLc1QerWHbpQCsdYDvVdQvGXgqXf84bNBSxBBOavsJSJ8YbOhc7pFSPgDER4eLGXzDchnoVOEwHS8oKoGQq3aShsNn6f9aivMWVeTjdTaNE_be-MrFjjnCjWpaiGJR38iDhmximBnpzD1Al435?key=vWCvjAUF9WlZE2WBqzzL4Q)

10. After launching the EC2 instances, next is to set up the ```Public Network Load Balancer (NLB)``` pointing to the Backend instances.<br />
	But before that, we need to create the Target groups first for our Public NLB.<br />
	Under the EC2 dashboard, go to ```Target Groups```, then click ```Create target group```.

| Target type | Target group name | Protocol:Port | IP address type | VPC | Health check protocol | Targets |
| --- | --- | --- | --- | --- | --- | --- |
| ```Instances``` | ```backend-TG``` | ```TCP:5000``` | ```IPv4``` | ```MERN VPC``` | ```TCP``` | ```backend-instance-1```<br />```backend-instance-2```<br />```backend-instance-3``` |
| ```Instances``` | ```mongo-TG``` | ```TCP:8081``` | ```IPv4``` | ```MERN VPC``` | ```TCP``` | ```EC2 Mongodb``` |

  We can now create the Public NLB. Under the EC2 dashboard, go to ```Load Balancers```, then click ```Create load balancer```.
  >Choose ```Network Load Balancer```, then click ```Create```.

| Load balancer name | Scheme | Load balancer IP address type | VPC | Availability Zones | Subnet | Security groups | Listeners and routing |
| --- | --- | --- | --- | --- | --- | --- | --- |
| ```Public-NLB``` | ```Internet-facing``` | ```IPv4``` | ```MERN VPC``` | ```us-east-1a``` | ```Public subnet``` | ```Public NLB-SG``` *(uncheck* ```default```*)* | ```Protocol: TCP```<br />```Port: 5000```<br />```Forward to: backend-TG```<br /><br />```Protocol: TCP```<br />```Port: 8081```<br />```Forward to: mongo-TG``` |

11. Lastly, we will now create an ```S3 Bucket``` which will serve as storage for images.<br />
	Navigate to S3 Management Console (type ```S3``` in the search bar), then click ```Create bucket```.

| Bucket type | Bucket name |
| --- | --- |
| ```General purpose```| *(give a unique name - e.g.* ```image-gallery-bucket-09162024```*)* |

  >Uncheck ```Block all public access```, and check the alert message box.
  Go back to ```Amazon S3```, then click ```Buckets```.<br />
  Select ```image-gallery-bucket-09162024```. Go to the ```Permissions``` tab.<br />
  Scroll down to ```Bucket policy```, then click ```Edit```. Copy/paste the following codes:
```
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Sid": "PublicReadGetObject",
           "Effect": "Allow",
           "Principal": "*",
           "Action": "s3:GetObject",
           "Resource": "arn:aws:s3:::<YOUR_BUCKET_NAME>/*"
       }
   ]
}
```
> [!IMPORTANT]
> Change the value for your ```<YOUR_BUCKET_NAME>```.
