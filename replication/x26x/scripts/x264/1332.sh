#!/bin/sh

numb='1333'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 3.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 0 --keyint 200 --lookahead-threads 1 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.5,1.1,1.4,3.6,0.2,0.6,0.1,2,1,6,0,200,1,27,10,5,0,65,18,5,2000,-2:-2,hex,crop,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"