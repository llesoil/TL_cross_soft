#!/bin/sh

numb='219'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 3.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 45 --keyint 250 --lookahead-threads 3 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 3 --qpmax 62 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset veryslow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.0,1.3,1.4,3.8,0.3,0.7,0.8,0,0,14,45,250,3,21,40,5,3,62,38,6,1000,-1:-1,dia,show,veryslow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"