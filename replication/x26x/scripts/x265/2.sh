#!/bin/sh

numb='3'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 1.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 35 --keyint 260 --lookahead-threads 3 --min-keyint 30 --qp 20 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,3.0,1.2,1.0,1.8,0.5,0.6,0.8,0,1,8,35,260,3,30,20,3,0,63,48,1,1000,-2:-2,dia,crop,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"