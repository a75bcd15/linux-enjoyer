#! /bin/bash
read -p "Enter the domain name that you want to brute-force: " DOMAIN_ NAME
function check_domain(){
	results=$(host $SUB_DOMAIN | grep 'has address')
	if [[ -n $results ]]
	then 
		printf "Found $SUB_DOMAIN\n"
		fi
}
for sub in $(cat sub-d.txt)
do 
	SUB_DOMAIN=$sub.$DOMAIN_NAME
	check_domain
done