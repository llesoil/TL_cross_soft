#!/bin/sh

numb='2150'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 3.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 20 --keyint 240 --lookahead-threads 2 --min-keyint 23 --qp 10 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.5,1.1,1.4,3.4,0.4,0.9,0.2,2,2,10,20,240,2,23,10,4,1,64,38,4,2000,-2:-2,hex,show,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"