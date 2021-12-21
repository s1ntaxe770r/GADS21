# GADS21
Final Project for the google andela scholarship project


For my final project i have chosen to take an Infrastructure as code approach to setting up a Kubernetes cluster on google cloud. 

This repos contains all the code necessary to up the cluster 

# Setup 
For the setup i am assuming you only have a google cloud account and the `gcloud` CLI installed. 

Start by cloning this repo `git clone https://github.com/s1ntaxe770r/GADS21 && cd GADS21`


- create a new GCP project by running `make project` 

- to store the terraform state i am making use of a remote backend so we would need a storage bucket for that. Run `make bucket` to provison an new storage bucket 

- It's best practice to use a service account for provisoning infrastructure in this manner so create a service account using `make sa` . This would create a new service account and generate keys 

-  before you can initalize the poject we need to grant the new service account permissons over our current project:

`export PROJECT_NAME=$( gcloud config get-value project)`

```bash
gcloud projects add-iam-policy-binding $PROJECT_NAME --member serviceAccount:$PROJECT_NAME@$PROJECT_NAME.iam.gserviceaccount.com --role roles/editor 
```
`export GOOGLE_APPLICATION_CREDENTIALS=gads21-service.json`


Now run `make plan` to create an execution plan.

Apart from provisoning a kubernetes cluster,  this terraform project would deploy [argocd](https://argo-cd.readthedocs.io/en/stable/user-guide/helm/) in the cluster , this would enable you to deploy applications using gitops thereby streamlining developer workflows. 

Run `make apply` once you are satisfied with the output and in a few minutes you should have a kubernetes cluster up and running. 

To access your cluster using kubectl, run the following command:
`gcloud container clusters get-credentials gads21-default --region us-east1`


### Notes

-  the size of the cluster can be configured using varibales defined in `variables.tf` 


## Takeaways from this project

This project has taught me alot about infrastructure as code and GitOps and i nowhave a better understanding of google cloud authentication through my use of service accounts.

## Improvements 
while i have argocd to automate cluster deployments a lot more automation could be done to automate how i provison using terraform ,  one idea i have is to use github actions to test my terraform deployments each time i make a change to one of the files. 

## Future plans
I plan to continue work on this going forward as it would serve as good refrence for me and anyone looking to do something similar. 


