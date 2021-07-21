deploy_infra:
	cd infrastructure && terraform apply -var-file=../ap-south.tfvars.json

destroy_infra:
	cd infrastructure && terraform destroy -var-file=../ap-south.tfvars.json

run_test:
	cd app && pipenv run python manage.py test

deploy:
	cd ansible && ansible-playbook deploy_service.yaml -i aws_ec2.yaml -v --ask-vault-pass --ask-become-pass

init_server:
	cd ansible && ansible-playbook deploy_service.yaml -i aws_ec2.yaml -v --ask-vault-pass --ask-become-pass --tags "server"

deploy_registry:
	cd ansible && ansible-playbook deploy_service.yaml -i aws_ec2.yaml -v --ask-vault-pass --ask-become-pass --tags "registry"

deploy_app:
	cd ansible && ansible-playbook deploy_service.yaml -i aws_ec2.yaml -v --ask-vault-pass --ask-become-pass --tags "app"

init_db:
	cd ansible && ansible-playbook deploy_service.yaml -i aws_ec2.yaml -v --ask-vault-pass --tags "initdb"


build:
	cd app && docker build . -t application-lb-317512653.ap-south-1.elb.amazonaws.com/v2/dockerapp:latest

push:
	cd app && docker push application-lb-317512653.ap-south-1.elb.amazonaws.com/v2/dockerapp:latest