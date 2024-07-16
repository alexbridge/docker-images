SHELL := /bin/bash

VOL_SQL := -v /var/lib/mysql:/var/lib/mysql
VOL_STATIC := -v /var/www/static:/var/www/static
VOL_DOCK := -v /var/run/docker.sock:/var/run/docker.sock
VOL_BCK := -v /var/backup:/var/backup

LOCAL_ANSIBLE := docker run -it $(VOL_SQL) $(VOL_STATIC) $(VOL_DOCK) $(VOL_BCK) welearn-ansible-local

exec-local-ansible:
	$(LOCAL_ANSIBLE) sh

ping-local-ansible:
	$(LOCAL_ANSIBLE) make ping-local-ansible
play-ping-local-ansible:
	$(LOCAL_ANSIBLE) make play-ping-local-ansible
play-welearn-backup-local-ansible:
	$(LOCAL_ANSIBLE) make play-welearn-backup-local-ansible