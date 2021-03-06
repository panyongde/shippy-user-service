build:
	protoc -I/usr/local/include -I. \
		--go_out=plugins=micro:. \
		proto/auth/auth.proto
	docker build -t panyongde/shippy-user-service:latest .
	docker login -u panyongde -p sisi18
	docker push panyongde/shippy-user-service:latest

run:
	docker run --net="host" \
		-p 50051 \
		-e DB_HOST=localhost \
		-e DB_PASS=password \
		-e DB_USER=postgres \
		-e MICRO_SERVER_ADDRESS=:50051 \
		-e MICRO_REGISTRY=mdns \
		panyongde/shippy-user-service

deploy:
	sed "s/{{ UPDATED_AT }}/$(shell date)/g" ./deployments/deployment.tmpl > ./deployments/deployment.yml
	kubectl apply -f ./deployments/deployment.yml
delete:
	kubectl delete ./deployments/deployment.yml
