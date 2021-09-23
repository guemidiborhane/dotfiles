#!/bin/bash

function pagespeed() {
    curl -s -w 'Testing Website Response Time for: %{url_effective}\n\nResponse Code:\t\t%{http_code}\nCookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null $1
}
