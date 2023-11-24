app1 := 57.180.53.238
app2 := 52.195.194.128
app3 := 13.230.232.66

local/ssh/%:
	$(eval ip=${${@F}})
	ssh isucon@${ip}

local/apply/%:
	$(eval ip=${${@F}})
	ssh isucon@${ip}

local/pull/%:
	$(eval ip=${${@F}})
	scp -r isucon@${ip}:~/etc/ etc/

remote/git/%:
	git fetch -p
	git switch ${@F}
	git pull

remote/setup:
	cd webapp/go/
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
