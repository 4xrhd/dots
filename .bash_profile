#----- AWS -------

s3ls(){
aws s3 ls s3://$1
}

s3cp(){
aws s3 cp $2 s3://$1 
}

#---- Content discovery ----
thewadl(){ #this grabs endpoints from a application.wadl and puts them in yahooapi.txt
curl -s $1 | grep path | sed -n "s/.*resource path=\"\(.*\)\".*/\1/p" | tee -a ~/tools/dirsearch/db/yahooapi.txt
}

#----- recon -----
crtndstry(){
./tools/crtndstry/crtndstry $1
}

am(){ #runs amass passively and saves to json
amass enum --passive -d $1 -json $1.json
jq .name $1.json | sed "s/\"//g"| httprobe -c 60 | tee -a $1-domains.txt
}

certprobe(){ #runs httprobe on all the hosts from certspotter
curl -s https://crt.sh/\?q\=\%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | httprobe | tee -a ./all.txt
}

mscan(){ #runs masscan
sudo masscan -p4443,2075,2076,6443,3868,3366,8443,8080,9443,9091,3000,8000,5900,8081,6000,10000,8181,3306,5000,4000,8888,5432,15672,9999,161,4044,7077,4040,9000,8089,443,744$}
}

certspotter(){ 
curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1
} #h/t Michiel Prins

crtsh(){
curl -s https://crt.sh/?Identity=%.$1 | grep ">*.$1" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$1" | sort -u | awk 'NF'
}

certnmap(){
curl https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1  | nmap -T5 -Pn -sS -i - -$
} #h/t Jobert Abma



#------ Tools ------


ncx(){
nc -l -n -vv -p $1 -k
}

crtshdirsearch(){ #gets all domains from crtsh, runs httprobe and then dir bruteforcers
curl -s https://crt.sh/?q\=%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | httprobe -c 50 | grep https | xargs -n1 -I{} python3 ~/tools/dirsearch/dirsearch.py -u {} -e $2 -t 50 -b 
}

_httpx_completions() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="
    -l -list -rr -request -u -target
    -sc -status-code -cl -content-length -ct -content-type -location -favicon -hash -jarm -rt -response-time -lc -line-count -wc -word-count -title -bp -body-preview -server -td -tech-detect -method -websocket -ip -cname -extract-fqdn -efqdn -asn -cdn -probe
    -ss -screenshot -system-chrome -ho -headless-options -esb -exclude-screenshot-bytes -ehb -exclude-headless-body -st -screenshot-timeout -sid -screenshot-idle
    -mc -match-code -ml -match-length -mlc -match-line-count -mwc -match-word-count -mfc -match-favicon -ms -match-string -mr -match-regex -mcdn -match-cdn -mrt -match-response-time -mdc -match-condition
    -er -extract-regex -ep -extract-preset
    -fc -filter-code -fep -filter-error-page -fd -filter-duplicates -fl -filter-length -flc -filter-line-count -fwc -filter-word-count -ffc -filter-favicon -fs -filter-string -fe -filter-regex -fcdn -filter-cdn -frt -filter-response-time -fdc -filter-condition -strip
    -t -threads -rl -rate-limit -rlm -rate-limit-minute
    -pa -probe-all-ips -p -ports -path -tls-probe -csp-probe -tls-grab -pipeline -http2 -vhost -ldv -list-dsl-variables
    -up -update -duc -disable-update-check
    -o -output -oa -output-all -sr -store-response -srd -store-response-dir -ob -omit-body -csv -csvo -csv-output-encoding -j -json -irh -include-response-header -irr -include-response -irrb -include-response-base64 -include-chain -store-chain -svrc -store-vision-recon-cluster -pr -protocol -fepp -filter-error-page-path
    -config -r -resolvers -allow -deny -sni -sni-name -random-agent -H -header -http-proxy -proxy -unsafe -resume -fr -follow-redirects -maxr -max-redirects -fhr -follow-host-redirects -rhsts -respect-hsts -vhost-input -x -body -s -stream -sd -skip-dedupe -ldp -leave-default-ports -ztls -no-decode -tlsi -tls-impersonate -no-stdin -hae -http-api-endpoint
    -health-check -hc -debug -debug-req -debug-resp -version -stats -profile-mem -silent -v -verbose -si -stats-interval -nc -no-color -tr -trace
    -nf -no-fallback -nfs -no-fallback-scheme -maxhr -max-host-error -e -exclude -retries -timeout -delay -rsts -response-size-to-save -rstr -response-size-to-read
    -auth -ac -auth-config -pd -dashboard -tid -team-id -aid -asset-id -aname -asset-name -pdu -dashboard-upload
    "

    if [[ ${cur} == -* ]]; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    fi
}



complete -F _httpx_completions httpx


_subfinder_completions() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="
    -cd
    -config
    -d
    -dL
    -exclude-sources
    -max-time
    -nC
    -nW
    -o
    -oD
    -oI
    -oJ
    -r
    -rL
    -silent
    -sources
    -t
    -timeout
    -v
    -version
    "
    if [[ ${cur} == -* ]]; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    fi
}
complete -F _subfinder_completions subfinder
