deploy_infra:
	cd infrastructure && terraform apply -var-file=../ap-south.tfvars.json


deploy_application:
	cd ansible && ansible-playbook configure_service.yaml -i aws_ec2.yaml -v --ask-vault-pass

destroy_infra:
	cd infrastructure && terraform destroy -var-file=../ap-south.tfvars.json
