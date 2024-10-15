# Configure the EC2 Instances

> [!IMPORTANT]
> Since ```backend-instance``` and ```EC2 Mongodb``` are **PRIVATE**, we cannot directly connect to them via SSH using our laptop.<br />
> To access these instances, we will be using ```frontend-instance``` as **JUMP HOST**.<br />
> To do this, we first need to connect to ```frontend-instance```, then from this *Public instance*, we can now connect to ```backend-instance``` and ```EC2 Mongodb``` via SSH.

## To configure EC2 Mongodb (database instance)

1. Since it is a ***Private instance***, we will first access ```frontend-instance-1```.<br />
Before accessing ```frontend-instance-1```, we need to copy the following from your local ```WSL machine``` to the remote ```frontend-instance-1```:
  - GitHub keys *(e.g.* ```id_ed25519``` *and* ```id_ed25519.pub```*)*
  - AWS Key pair *(e.g.* ```MERN.pem```*)* 
> Identify first the ```Public IPv4 address``` of ```frontend-instance-1```.<br />
> To do this, go back to EC2 Management Console, then click ```Instances```. Select ```frontend-instance-1```, and navigate to the ```Details``` tab, then copy the ```Public IPv4 address```.<br />
> Open ```WSL Terminal``` on your laptop/desktop. Make sure your ```AWS Key pair``` (e.g. ```MERN.pem```) is available and located in your working directory where you’ll be executing commands.<br />
> Run the following commands:
```
chmod 400 MERN.pem

scp -i $HOME/MERN.pem $HOME/.ssh/id_ed25519 ec2-user@18.210.12.57:~/.ssh/

scp -i $HOME/MERN.pem $HOME/.ssh/id_ed25519.pub ec2-user@18.210.12.57:~/.ssh/

scp -i $HOME/MERN.pem $HOME/MERN.pem ec2-user@18.210.12.57:~/
```
> [!IMPORTANT]
> Command template:<br />
> ```scp -i <PATH_TO_LOCAL_AWS_KEY_PAIR> <PATH_TO_LOCAL_GITHUB_KEY> ec2-user@<PUBLIC_IPV4_ADDRESS_FRONTEND-INSTANCE-1>:~/.ssh/```

> [!NOTE]
> You will be asked, ```Are you sure you want to continue connecting?```, type ```yes```, then press ```Enter```.

2. We will now access ```frontend-instance-1``` from the ```WSL machine```.<br /> 
Go back to EC2 Management Console, then click ```Instances```. Select ```frontend-instance-1```, then click ```Connect```.

3. Navigate to the ```SSH client``` tab to connect via SSH. 

4. Copy the SSH command stated in the ```Example:```*(e.g.* ```ssh -i “MERN.pem” ec2-user@ec2-3-250-71-154.us-east-1.compute.amazonaws.com```*)*.

5. Switch to ```WSL Terminal```.<br />
Run the SSH command you copied from the ```Example:```.

6. You are now inside the ```frontend-instance-1```.<br />
	Before accessing the ```EC2 Mongodb```, copy the GitHub keys ```id_ed25519``` and ```id_ed25519.pub``` from ```frontend-instance-1``` to ```EC2 Mongodb```.
> Identify first the ```Private IPv4 address``` of ```EC2 Mongodb```.<br />
> To do this, go back to EC2 Management Console, then click ```Instances```. Select ```EC2 Mongodb```, and navigate to the ```Details``` tab, then copy the ```Private IPv4 address```.<br />
> Switch back to ```WSL Terminal``` *(it should be still inside* ```frontend-instance-1```*)*.<br />
> Run the following commands:
```
scp -i $HOME/MERN.pem $HOME/.ssh/id_ed25519 ec2-user@10.0.2.57:~/.ssh/

scp -i $HOME/MERN.pem $HOME/.ssh/id_ed25519.pub ec2-user@10.0.2.57:~/.ssh/
```
> [!IMPORTANT]
> Take note of the ```EC2 Mongodb Private IPv4 address``` will be the destination IP.

> [!NOTE]
> You will be asked, ```Are you sure you want to continue connecting?```, type ```yes```, then press ```Enter```.

7. Finally, we will now access ```EC2 Mongodb``` from ```frontend-instance-1```.<br />
	Do the same process in copying the SSH command to connect, but this time, select ```EC2 Mongodb``` from the ```Instances``` page.

8. Switch back to ```WSL Terminal``` *(it should be still inside* ```frontend-instance-1```*)*.<br />
Run the SSH command to connect to ```EC2 Mongodb```.<br />

9. You are now inside the ```EC2 Mongodb```.<br />
We will now clone this GitHub repo, by running this command:
```
git clone git@github.com:jbetueldev/mern-gallery-sample-app.git
```

> [!NOTE]
> You will be asked, ```Are you sure you want to continue connecting?```, type ```yes```, then press ```Enter```.

10. Navigate to the path containing the specific application to be installed for this specific instance.<br />
Run this command:
```
cd mern-gallery-sample-app/ec2-mongodb
```

11. Prepare the environment variables. <br />
  Check ```.env.sample``` for the example by running:
```
cat .env.sample
```
  Create a new ```.env``` file, run the command:
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

## To configure backend-instance-1

1. The same with ```EC2 Mongodb```, it is also a ***Private instance***, thus, we will first access ```frontend-instance-1```.<br />
Switch to a new ```WSL Terminal``` *(it should be inside your* ```WSL machine```*)*.<br />
Do the same process to access ```frontend-instance-1``` from the ```WSL machine```.

2. You are now inside the ```frontend-instance-1```.<br />
Before accessing the ```backend-instance-1```, do the same process in copying the GitHub keys, but this time from ```frontend-instance-1``` to ```backend-instance-1```.
> We will now use the ```Private IPv4 address``` of ```backend-instance-1```.<br />
> Switch back to ```WSL Terminal``` *(it should be still inside* ```frontend-instance-1```*)*.<br />
> Run the following commands:
```
scp -i $HOME/MERN.pem $HOME/.ssh/id_ed25519 ec2-user@10.0.2.12:~/.ssh/

scp -i $HOME/MERN.pem $HOME/.ssh/id_ed25519.pub ec2-user@10.0.2.12:~/.ssh/
```
> [!IMPORTANT]
> Take note of the ```backend-instance-1 Private IPv4 address``` will be the destination IP.

> [!NOTE]
> You will be asked, ```Are you sure you want to continue connecting?```, type ```yes```, then press ```Enter```.

3. We will now access ```backend-instance-1``` from ```frontend-instance-1```.<br />
Do the same process in copying the SSH command to connect, but this time, select ```backend-instance-1``` from the ```Instances``` page.

4. Run the SSH command to connect to ```backend-instance-1```.

5. You are now inside the ```backend-instance-1```.<br />
Clone this GitHub repo by running the same command before.

6. Navigate to the path containing the specific application to be installed for this specific instance.<br />
Run this command:
```
cd mern-gallery-sample-app/backend-instance
```

7. Prepare the environment variables.<br />
We will now use your ```AWS IAM User Access key```.<br />
To copy your ```AWS credentials```, open the ```.csv``` file you downloaded when creating the access key.<br />
Check ```.env.sample``` for the example by running the same command: ```cat .env.sample```.<br />
Create a new ```.env``` file, run the same command: ```vim .env```.

8. Build and run the application, run these commands:
```
docker buildx build -t mern-backend:latest .
docker run -p 5000:5000 -d --restart always mern-backend:latest
```

9. Verify if the docker container ```mern-backend``` is running, run the same command: ```docker ps```.

10. To test if it’s properly working, run this:
```
docker logs <CONTAINER_ID>
```
> [!IMPORTANT]
> Change the value of ```<CONTAINER_ID>``` from the output of the previous command.<br />
> It should output: ```Connected to MongoDB```

> [!TIP]
> Do the same configuration on ```backend-instance-2``` and ```backend-instance-3``` as we did in ```backend-instance-1```.

## To configure frontend-instance-1

1. Switch to a new ```WSL Terminal``` *(it should be inside your* ```WSL machine```*)*.<br />
Do the same process to access ```frontend-instance-1``` from the ```WSL machine```.

2. You are now inside the ```frontend-instance-1```.<br />
Clone this GitHub repo by running the same command before.

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
> Do the same configuration on ```frontend-instance-2``` as we did in ```frontend-instance-1```.

## To configure Proxy server (NGINX instance)

1. Before accessing the ```Proxy server```, do the same process in copying the GitHub keys, but this time from your local ```WSL machine``` to the remote ```Proxy server```.
> We will now use the ```Public IPv4 address``` of ```Proxy server```.<br />
> Switch to a new ```WSL Terminal``` *(it should be inside your* ```WSL machine```*)*.<br />
> Run the following commands:
```
scp -i $HOME/MERN.pem $HOME/.ssh/id_ed25519 ec2-user@18.210.22.35:~/.ssh/

scp -i $HOME/MERN.pem $HOME/.ssh/id_ed25519.pub ec2-user@18.210.22.35:~/.ssh/
```
> [!IMPORTANT]
> Take note of the ```Proxy server Public IPv4 address``` will be the destination IP.

> [!NOTE]
> You will be asked, ```Are you sure you want to continue connecting?```, type ```yes```, then press ```Enter```.

2. We will now access ```Proxy server``` from the ```WSL machine```.<br />
Do the same process in copying the SSH command to connect, but this time, select ```Proxy server``` from the ```Instances``` page.

3. You are now inside the ```Proxy server```.<br />
Clone this GitHub repo by running the same command before.

4. Navigate to the path containing the specific application to be installed for this specific instance.<br />
Run this command:
```
cd mern-gallery-sample-app/proxy-server
```

5. Edit the file ```mern.conf``` by running:
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

6. Copy the config file ```mern.conf``` to ```/etc/nginx/conf.d/```, run this command:
```
sudo cp mern.conf /etc/nginx/conf.d/mern.conf
```

7. Edit the config file ```nginx.conf``` by running:
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

8. Restart NGINX service by running:
```
sudo systemctl restart nginx
```

9. Verify if NGINX service is running, run this:
```
sudo systemctl status nginx
```

---
### Our application is now deployed in AWS, and ready for testing.<br />
- [Accessing the App from Browser](README.md#accessing-the-app-from-browser)
- [Accessing Mongo-Express from Browser](README.md#accessing-mongo-express-from-browser)
