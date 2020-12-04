#!/bin/sh

numb='235'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 2.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 30 --keyint 250 --lookahead-threads 4 --min-keyint 23 --qp 10 --qpstep 5 --qpmin 2 --qpmax 64 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.5,1.1,2.2,0.2,0.9,0.1,1,0,6,30,250,4,23,10,5,2,64,48,5,2000,-2:-2,umh,crop,superfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"