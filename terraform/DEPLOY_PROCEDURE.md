# Deploy MERN Image Gallery Todo Sample App on AWS using Terraform

## Prerequisites

- AWS account 
- AWS IAM User Access key *(it should be downloaded in your laptop -* ```.csv``` *file)*
- AWS Key pair *(it should be available in your WSL machine -* ```.pem``` *file)*
- ```AWS CLI``` installed in your WSL machine
- ```Terraform``` installed in your WSL machine

## Set up the AWS Infrastructure using Terraform

> [!IMPORTANT]
> If ```AWS CLI``` and ```Terraform``` are both already installed in your WSL/local machine,<br>
> as well as the ```AWS credentials``` are already configured,<br>
> you may SKIP steps 1-3.

1. Install ```AWS CLI``` in you WSL machine by running the following commands:
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
> Confirm the installation with this command: ```aws --version```

2. Terraform will use your AWS credentials to authenticate itself and make API calls to create and manage resources on your behalf.<br>
    Set your AWS credentials for the current environment by running:
```
aws configure
```
> [!IMPORTANT]
> Enter the corresponding values from the ```.csv``` file containing your ```AWS IAM User Access key```<br>
> Default region name: ```us-east-1```<br>
> Default output format: ```json```

3. Install ```Terraform``` in you WSL machine by running the following commands:
```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```
> Confirm the installation with this command: ```terraform --version```

4. Clone the remote repo in your WSL machine:
```
git clone https://github.com/jbetueldev/mern-gallery-sample-app.git
```

5. Navigate to the path containing the Terraform configuration files:
```
cd mern-gallery-sample-app/terraform
```

6. Before initializing, you need to set up first the remote backend for the Terraform state file.<br>
    Log in to your AWS Management Console, then go to ```Amazon S3```.<br>
    Click ```Create bucket```

| Bucket type  | Bucket name | Block all public access | Bucket Versioning|
| --- | --- | --- | --- |
| ```General purpose``` | *(globally unique name - e.g.* ```r3m0t3-s3-bucket```*)* | *(checked)* | Enable |

7. Next is to create a DynamoDB table for statelock.<br>
    In your AWS Management Console, go to ```Amazon DynamoDB```.<br>
    Click ```Create table```

| Table name  | Partition key |
| --- | --- |
| *(e.g.* ```terraform-state-table```*)* | LockID |

8. Going back to your WSL CLI, check the configuration file ```terraform.tf``` if it matches the names of the created S3 bucket and DynamoDB table.<br>
    Make necessary edits, and see comments for your reference.
```
vim terraform.tf
```

9. To deploy the resources to AWS, execute the following commands:
```
terraform init
```
```
terraform apply -auto-approve
```

10. Your resources are now deployed on AWS. Verify on your AWS Management Console.<br>
    Next steps will be configuring the EC2 instances.

<br>
<br>

## Configure the EC2 Instances

> [!IMPORTANT]
> Since ```backend-instance``` and ```EC2 Mongodb``` are **PRIVATE**, you cannot directly connect to them via SSH from your WSL machine.<br />
> To access these instances, use ```NAT-instance``` as **JUMP HOST**.<br />
> To do this, you first need to connect to ```NAT-instance```, then from this *Public instance*, you can now connect to ```backend-instance``` and ```EC2 Mongodb``` via SSH.

### I. To configure EC2 Mongodb (database instance)

1. Since it is a ***Private instance***, you will first access ```NAT-instance```.<br />
Before accessing ```NAT-instance```, you need to copy the AWS Key pair *(e.g.* ```MERN.pem```*)* from your local ```WSL machine``` to the remote ```NAT-instance```.
> Identify first the ```Public IPv4 address``` of ```NAT-instance```.<br />
> To do this, go back to EC2 Management Console, then click ```Instances```. Select ```NAT-instance```, and navigate to the ```Details``` tab, then copy the ```Public IPv4 address```.<br />
> Open ```WSL Terminal``` on your laptop/desktop. Make sure your ```AWS Key pair``` (e.g. ```MERN.pem```) is available and located in your working directory where you’ll be executing commands.<br />
> Run the following commands:
```
chmod 400 MERN.pem

scp -i $HOME/MERN.pem $HOME/MERN.pem ec2-user@18.210.12.57:~/
```
> [!IMPORTANT]
> Command template:<br />
> ```scp -i <PATH_TO_LOCAL_AWS_KEY_PAIR> <PATH_TO_LOCAL_AWS_KEY_PAIR> ec2-user@<PUBLIC_IPV4_ADDRESS_NAT-INSTANCE>:~/.ssh/```

> [!NOTE]
> You will be asked, ```Are you sure you want to continue connecting?```, type ```yes```, then press ```Enter```.

2. You will now access ```NAT-instance``` from your ```WSL machine```.<br /> 
Go back to EC2 Management Console, then click ```Instances```. Select ```NAT-instance```, then click ```Connect```.

3. Navigate to the ```SSH client``` tab to connect via SSH. 

4. Copy the SSH command stated in the ```Example:```*(e.g.* ```ssh -i “MERN.pem” ec2-user@ec2-3-250-71-154.us-east-1.compute.amazonaws.com```*)*.

5. Switch to ```WSL Terminal```.<br />
Run the SSH command you copied from the ```Example:```.

6. You are now inside the ```NAT-instance```.<br />
You will now access ```EC2 Mongodb``` from ```NAT-instance```.<br />
Do the same process in copying the SSH command to connect, but this time, select ```EC2 Mongodb``` from the ```Instances``` page.

7. Switch back to ```WSL Terminal``` *(it should be still inside* ```NAT-instance```*)*.<br />
Run the SSH command to connect to ```EC2 Mongodb```.<br />

8. You are now inside the ```EC2 Mongodb```.<br />
You will now clone this GitHub repo, by running this command:
```
git clone https://github.com/jbetueldev/mern-gallery-sample-app.git
```

> [!NOTE]
> You will be asked, ```Are you sure you want to continue connecting?```, type ```yes```, then press ```Enter```.

10. Navigate to the path containing the specific application to be installed for this specific instance.<br />
Run this command:
```
cd mern-gallery-sample-app/ec2-mongodb
```

11. Prepare the environment variables. <br />
  Rename ```.env.sample``` to ```.env``` by running:
```
mv .env.sample .env
```
  Edit ```.env``` file, run the command:
```
vim .env
```

12. Build and run the application, run the command:
```
docker-compose up -d --build
```

13. Verify if the docker containers ```mongodb``` and ```mongo-express``` are running, run the command:
```
docker ps
```

<br>

### II. To configure backend-instance-1

1. The same with ```EC2 Mongodb```, it is also a ***Private instance***, thus, you will first access ```NAT-instance```.<br />
Switch to a new ```WSL Terminal``` *(it should be inside your* ```WSL machine```*)*.<br />
Do the same process to access ```NAT-instance``` from the ```WSL machine```.

2. You are now inside the ```NAT-instance```.<br />
You will now access ```backend-instance-1``` from ```NAT-instance```.<br />
Do the same process in copying the SSH command to connect, but this time, select ```backend-instance-1``` from the ```Instances``` page.

3. Run the SSH command to connect to ```backend-instance-1```.

4. You are now inside the ```backend-instance-1```.<br />
Clone the same GitHub repo by running the same command before.

5. Navigate to the path containing the specific application to be installed for this specific instance.<br />
Run this command:
```
cd mern-gallery-sample-app/backend-instance
```

6. Prepare the environment variables.<br />
You will now use your ```AWS IAM User Access key```.<br />
To copy your ```AWS credentials```, open the ```.csv``` file you downloaded when creating the access key.<br />
Rename ```.env.sample``` to ```.env``` by running the same command: ```mv .env.sample .env```<br />
Edit ```.env``` file, run the same command: ```vim .env```

7. Build and run the application, run these commands:
```
docker buildx build -t mern-backend:latest .
```
```
docker run --name backend -p 5000:5000 -d --restart always mern-backend:latest
```

8. Verify if the docker container ```backend``` is running, run the same command: ```docker ps```.

9. To test if it’s properly working, run this:
```
docker logs backend
```
> [!IMPORTANT]
> It should output: ```Connected to MongoDB```

> [!TIP]
> Do the same configuration on ```backend-instance-2``` and ```backend-instance-3``` as you did in ```backend-instance-1```.

<br>

### III. To configure frontend-instance-1

1. Switch to a new ```WSL Terminal``` *(it should be inside your* ```WSL machine```*)*.<br />
The same with ```NAT-instance```, it is also a ***Public instance***.<br>
Do the same process with accessing ```NAT-instance``` to access ```frontend-instance-1``` from the ```WSL machine``` using its ```Public IPv4 address```.

2. You are now inside the ```frontend-instance-1```.<br />
Clone the same GitHub repo by running the same command before.

3. Navigate to the path containing the specific application to be installed for this specific instance.<br />
Run this command:
```
cd mern-gallery-sample-app/frontend-instance
```

4. Edit the file ```docker-compose.yml``` by running:
```
vim docker-compose.yml
```

> [!IMPORTANT]
> Search for this line:
> ```
> VITE_BACKEND_ENDPOINT: http://<PUBLIC_NLB_DNS_NAME>:5000
> ```
> Replace ```<PUBLIC_NLB_DNS_NAME>``` with its corresponding value.<br />
> To copy your ```Public NLB DNS name```, go back to the AWS console, and search for ```Load balancers```.<br />
> Select ```Public-NLB```, then copy the ```DNS name```.

5. Build and run the application, run this command:
```
docker-compose up -d --build
```

6. Verify if the docker containers ```frontend``` and ```nginx``` are running, run the same command: ```docker ps```.

> [!TIP]
> Do the same configuration on ```frontend-instance-2``` as you did in ```frontend-instance-1```.

<br>

### IV. To configure Proxy server (NGINX instance)

1. Switch to a new ```WSL Terminal``` *(it should be inside your* ```WSL machine```*)*.<br />
The same with ```NAT-instance```, it is also a ***Public instance***.<br>
Do the same process with accessing ```NAT-instance``` to access ```Proxy server``` from the ```WSL machine``` using its ```Public IPv4 address```.

2. You are now inside the ```Proxy server```.<br />
Clone the same GitHub repo by running the same command before.

3. Navigate to the path containing the specific application to be installed for this specific instance.<br />
Run this command:
```
cd mern-gallery-sample-app/proxy-server
```

4. Edit the file ```mern.conf``` by running:
```
vim mern.conf
```

> [!IMPORTANT]
> Search for:
> ```
> server <FRONTEND-INSTANCE-1_PRIVATE_IP>; # frontend-instance-1
> server <FRONTEND-INSTANCE-2_PRIVATE_IP>; # frontend-instance-2
>
> server <PUBLIC_NLB_DNS_NAME>:8081;
> ```
> Replace ```<FRONTEND-INSTANCE-1_PRIVATE_IP>```, ```<FRONTEND-INSTANCE-2_PRIVATE_IP>```, ```<PUBLIC_NLB_DNS_NAME>``` with their corresponding values.

5. Copy the config file ```mern.conf``` to ```/etc/nginx/conf.d/```, run this command:
```
sudo cp mern.conf /etc/nginx/conf.d/mern.conf
```

6. Edit the config file ```nginx.conf``` by running:
```
sudo vim /etc/nginx/nginx.conf
```

> [!IMPORTANT]
> Search for:
> ```
>     server {
>        listen       80;
>        listen       [::]:80;
>        server_name  _;
>        root         /usr/share/nginx/html;
>
> 	# Load configuration files for the default server block.
>        include /etc/nginx/default.d/*.conf;
>
>        error_page 404 /404.html;
>        location = /404.html {
>        }
>
>        error_page 500 502 503 504 /50x.html;
>        location = /50x.html {
>        }
>    }
> ```
> Comment out these lines of code. Use ```#``` at the beginning of each lines.

7. Restart NGINX service by running:
```
sudo systemctl restart nginx
```

8. Verify if NGINX service is running, run this:
```
sudo systemctl status nginx
```

<br>
<br>

## Accessing the App from Browser

1. You can access the MERN app thru the ```Public IPv4 address``` of the ```Proxy server```.<br />
Go back to EC2 Management Console, then click ```Instances```.<br />
Select ```Proxy server```, and navigate to the ```Details``` tab, then copy the ```Public IPv4 address```.

2. Access this IP address into your browser, and the MERN Image Gallery Todo Sample app will show.

3. To test the ```To do List``` section, fill up the ```Add new todo Item```, then click ```Add task```.<br />
	Reload the page, then the ```todo item``` should be displayed on ```To do List```.

4. If you click ```Delete```, then reload the page, the ```todo item``` should be removed.

5. To test the ```Images``` section, click ```Choose file```, then select a local image, and click ```Upload```.<br />
	Reload the page, then the image should be displayed on ```Images```.

## Accessing Mongo-Express from Browser

We can access Mongo-Express thru the ```Public IPv4 address``` of the ```Proxy server``` at ```Port 8081```.
```
<PROXY_SERVER_PUBLIC_IP>:8081
```
> [!IMPORTANT]
> You will be asked for the username and password. Use the default values:<br />
> Username: ```admin```<br/>
> Password: ```pass```