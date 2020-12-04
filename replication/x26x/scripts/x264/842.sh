#!/bin/sh

numb='843'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 10 --keyint 230 --lookahead-threads 0 --min-keyint 27 --qp 0 --qpstep 4 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.5,1.6,1.1,4.8,0.4,0.7,0.1,0,2,4,10,230,0,27,0,4,4,66,38,6,2000,-1:-1,umh,show,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"