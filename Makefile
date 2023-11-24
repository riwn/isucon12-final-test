include makefile.env

local/ssh/%:
	$(eval ip=${${@F}})
	ssh isucon@${ip}

local/apply/%:
	$(eval ip=${${@F}})
	rsync -v -e ssh Makefile isucon@${ip}:~/
	rsync -rv --delete -e ssh go/ isucon@${ip}:~/webapp/go/

local/pull/%:
	$(eval ip=${${@F}})
	scp -r isucon@${ip}:~/etc/ etc/

local/setup/%:
	$(eval ip=${${@F}})
	ssh isucon@${ip} bash --login -c "make remote/setup"

remote/git/%:
	git fetch -p
	git switch ${@F}
	git pull

remote/setup:
	cd webapp/go/ && \
	go mod tidy && \
	go build -o isuconquest ./...
	sudo rsync etc/nginx/ /etc/nginx/
	sudo rsync etc/mysql/ /etc/mysql/
	sudo chown -R root:root /etc/nginx
	sudo chown -R root:root /etc/mysql
	sudo systemctl daemon-reload
	sudo systemctl enable mysql nginx isuconquest.go.service
	sudo systemctl restart mysql nginx isuconquest.go.service

remote/prepare-bench:
	# log rotate
	
remote/report-bench:
	# log rotate
	# log post to discord
