#!/bin/sh

numb='2269'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 30 --keyint 220 --lookahead-threads 0 --min-keyint 23 --qp 50 --qpstep 3 --qpmin 2 --qpmax 64 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.1,1.1,2.2,0.2,0.8,0.5,0,2,6,30,220,0,23,50,3,2,64,28,4,1000,1:1,hex,crop,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"