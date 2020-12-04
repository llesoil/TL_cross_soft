#!/bin/sh

numb='1935'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --intra-refresh --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 2.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 15 --keyint 270 --lookahead-threads 2 --min-keyint 29 --qp 0 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,--intra-refresh,None,--slow-firstpass,--weightb,2.0,1.5,1.1,2.8,0.5,0.7,0.4,3,2,16,15,270,2,29,0,5,0,63,18,1,2000,-1:-1,umh,show,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"