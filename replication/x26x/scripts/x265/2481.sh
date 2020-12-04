#!/bin/sh

numb='2482'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 45 --keyint 290 --lookahead-threads 4 --min-keyint 27 --qp 10 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,2.5,1.3,1.1,4.4,0.4,0.8,0.0,0,1,0,45,290,4,27,10,3,2,65,48,1,2000,1:1,dia,show,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"