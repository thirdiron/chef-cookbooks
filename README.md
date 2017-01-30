# chef-cookbooks
I'm giving OpsWorks a spin and it needs a repository from which to pull custom chef cookbooks

Relevant Devtools:
 - ChefDK: [OSX](https://downloads.chef.io/chef-dk/mac/)

## Useful AWS Documentation
 - [Instance Attributes](http://docs.aws.amazon.com/opsworks/latest/userguide/attributes-json-opsworks-instance.html)

## How to update Opsworks-managed machines when changing these cookbooks

1. Make a change to the cookbook and commit the change directly to `master`
2. Inside the AWS Console's Opsworks UI, choose the applicable stack, click "Run Command", and run the "Update Custom Cookbooks" command

## How to update Opsworks-managed machines when changing these cookbooks and you need to run Setup

Running "Setup" should not be needed to be done frequently.  However, when it is needed (such as when creating a new instance from scratch), follow these instructions:
1. Make a change to the cookbook and commit the change directly to `master`
2. Inside the AWS Console's Opsworks UI, choose the applicable stack, click "Run Command", and run the "Update Custom Cookbooks" command
3. Inside the AWS Console's Opsworks UI, choose the applicable stack, click "Run Command", and run the "Setup" command

## To-do

- [ ] Enable local testing of running these cookbooks rather than having to do it on instances in the cloud on AWS
- [ ] Speed up loading of changes in Opsworks by making an image the machines can start from which is essentially a freshly-booted Ubuntu image: this is the recommend way online to speed up deploys and spinning up Opsworks-managed machines.
