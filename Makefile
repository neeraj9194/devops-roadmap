deploy_infra:
	cd infrastructure && terraform apply -var-file=../ap-south.tfvars.json

deploy_application:
	cd ansible && ansible-playbook configure_service.yaml -i aws_ec2.yaml -v --ask-vault-pass

destroy_infra:
	cd infrastructure && terraform destroy -var-file=../ap-south.tfvars.json

run_test:
	cd app && pipenv run python manage.py test

build:
	cd app && docker build . -t application-lb-317512653.ap-south-1.elb.amazonaws.com/v2/dockerapp:latest

push:
	cd app && docker push application-lb-317512653.ap-south-1.elb.amazonaws.com/v2/dockerapp:latest