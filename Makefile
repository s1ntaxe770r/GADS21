PROJECT_NAME=gads21
TF_STATE=$(PROJECT_NAME)-tfstate
PROJECT_REGION=us-east1




# create default google cloud project
project:
	-gcloud projects create $(PROJECT_NAME)
	gcloud config set project $(PROJECT_NAME)

# create storage bucket to store terraform remote state 
bucket:
	gsutil mb -l $(PROJECT_REGION) gs://$(TF_STATE)


plan:
	terraform plan -out=plan 

apply:
	terraform apply plan 

fmt:
	terraform fmt .

sa:
	-gcloud iam service-accounts create $(PROJECT_NAME)
	gcloud iam service-accounts keys create $(PROJECT_NAME)-service.json --iam-account=$(PROJECT_NAME)@$(PROJECT_NAME).iam.gserviceaccount.com
        gcloud projects add-iam-policy-binding $PROJECT_NAME --member serviceAccount:$PROJECT_NAME@$PROJECT_NAME.iam.gserviceaccount.com --role roles/editor



