#!/bin/sh

numb='2512'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 5.0 --qblur 0.5 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 30 --keyint 210 --lookahead-threads 0 --min-keyint 20 --qp 30 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.0,1.4,1.2,5.0,0.5,0.9,0.1,3,2,0,30,210,0,20,30,3,0,66,38,2,1000,1:1,hex,show,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"