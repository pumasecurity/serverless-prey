.PHONY: gomodgen deploy delete

gomodgen:
	GO111MODULE=on go mod init cheetah

deploy:
	gcloud functions deploy cheetah --entry-point Cheetah --runtime go111 --trigger-http

delete:
	gcloud functions delete cheetah --entry-point Cheetah --runtime go111 --trigger-http
