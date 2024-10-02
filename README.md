# MERN Image Gallery Todo Sample App (AWS deployment)
- Frontend: ```React```, ```Bootstrap```
- Backend: ```Node.js```, ```Express```
- Database: ```Mongo``` *(for storing tasks)* with ```Mongo-Express``` *(to manage interactively)*
- Object Storage: ```AWS S3```

## Project Structure

This project contains the following components:
- ```/backend-instance``` - This directory contains the Node.js application that handles the server-side logic and interacts with the database. This directory contains configuration settings for uploading images to AWS S3. The uploadConfig.js file is responsible for configuring the S3 client to connect to the S3 endpoint. This allows the backend application to store and retrieve images associated with the image items.
- ```/ec2-mongodb``` - This directory contains the docker-compose YAML file to configure Mongo and Mongo-Express.
- ```/frontend-instance``` - This directory contains the docker-compose YAML file to configure the frontend application and NGINX. The ```/frontend``` sub-directory contains the React application that handles the user interface and interacts with the backend, while the ```/nginx``` sub-directory contains the NGINX configuration file for reverse-proxy.
- ```/proxy-server``` - This directory contains the NGINX configuration file for reverse-proxy and load balancing. This config file also includes proxy pass for Mongo-Express.

## Prerequisites

- AWS account 
- AWS IAM User Access key *(it should be downloaded in your laptop -* ```.csv``` *file)*
- AWS Key pair *(it should be available in your WSL machine -* ```.pem``` *file)*  
- GitHub account
- GitHub SSH key *(it should be generated from your WSL machine)*

## Deploying the App in AWS

1. &nbsp;&nbsp;[SET UP THE AWS INFRASTRUCTURE](SET_UP_AWS_INFRA.md)
2. &nbsp;&nbsp;[CONFIGURE THE EC2 INSTANCES](CONFIG_INSTANCES.md)

## Accessing the App from Browser

1. We can access our MERN app thru the ```Public IPv4 address``` of the ```Proxy server```.<br />
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
