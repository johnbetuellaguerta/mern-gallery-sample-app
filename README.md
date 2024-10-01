# MERN Image Gallery Todo Sample App (AWS deployment)
- Frontend: React, Bootstrap.
- Backend: Node.js, Express
- Database: Mongo (for storing tasks)
- Object Storage: S3

## Project Structure

This project contains the following components:
- **/backend-instance** - This directory contains the Node.js application that handles the server-side logic and interacts with the database. This directory contains configuration settings for uploading images to AWS S3. The uploadConfig.js file is responsible for configuring the S3 client to connect to the S3 endpoint. This allows the backend application to store and retrieve images associated with the image items.
- **/ec2-mongodb** - This directory contains the docker-compose YAML file to configure Mongo and Mongo-Express.
- **/frontend-instance** - This directory contains the docker-compose YAML file to configure the frontend application and NGINX. The **/frontend** sub-directory contains the React application that handles the user interface and interacts with the backend, while the **/nginx** sub-directory contains the NGINX configuration file for reverse-proxy.
- **/proxy-server** - This directory contains the NGINX configuration file for reverse-proxy and load balancing. This config file also includes proxy pass for Mongo-Express.

## Prerequisites

- AWS account 
- AWS IAM User Access key (it should be downloaded in your laptop - **.csv** file)
- AWS Key pair (it should be available in your WSL machine - **.pem** file)  
- GitHub account
- GitHub SSH key (it should be generated from your WSL machine)

## Deploying the App in AWS

1. &nbsp;&nbsp;[SET UP THE AWS INFRASTRUCTURE](SET_UP_AWS_INFRA.md)
2. &nbsp;&nbsp;[CONFIGURE THE EC2 INSTANCES](CONFIG_INSTANCES.md)

## Accessing the App from Browser

## Accessing Mongo-Express from Browser
