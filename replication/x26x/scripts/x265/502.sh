#!/bin/sh

numb='503'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 25 --keyint 230 --lookahead-threads 3 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.0,1.6,1.1,4.0,0.3,0.8,0.9,3,0,14,25,230,3,29,40,4,1,68,18,3,2000,-1:-1,dia,show,slower,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"