REGION=eu-north-1
PROFILE=default
STACK=tictactoe
ARTIFACT_BUCKET=${STACK}-artifacts
STACK_BUCKET=${STACK}-bucket

generate:
	test -f template.yaml || cp example.template.yaml template.yaml
	aws s3 mb s3://${ARTIFACT_BUCKET} --profile ${PROFILE}

build: clean
	GOOS=linux GOARCH=amd64 go build -o game/main ./game/main.go

clean: 
	rm -rf ./game/main

package:
	sam package --template-file template.yaml --output-template-file packaged.yaml --s3-bucket ${ARTIFACT_BUCKET} --profile ${PROFILE}

deploy: build package
	aws cloudformation deploy --template-file packaged.yaml --stack-name ${STACK} --capabilities CAPABILITY_NAMED_IAM --region ${REGION} --profile ${PROFILE}

delete:
	aws cloudformation delete-stack --stack-name ${STACK} --region ${REGION} --profile ${PROFILE}