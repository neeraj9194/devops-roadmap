deploy_infra:
	cd infrastructure
	terraform apply -var-file=../ap-south.tfvars.json
	cd ..

deploy_application:
	cd ansible
	ansible-playbook configure_service.yaml -i aws_ec2.yaml -v --ask-vault-pass
	cd ..	

destroy_infra:
	cd infrastructure
	terraform state rm aws_s3_bucket.registry-bucket 
	terraform destroy -var-file=../ap-south.tfvars.json
	cd ..
