#!/bin/sh

numb='1351'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 1.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.8 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 10 --keyint 230 --lookahead-threads 2 --min-keyint 22 --qp 50 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.0,1.6,1.0,1.4,0.6,0.7,0.8,3,2,16,10,230,2,22,50,4,1,60,18,2,2000,1:1,hex,show,slow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"