#!/bin/sh

numb='1891'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 0.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 0 --keyint 270 --lookahead-threads 2 --min-keyint 23 --qp 0 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.5,1.2,0.8,0.4,0.8,0.9,0,1,0,0,270,2,23,0,4,3,67,38,1,1000,-2:-2,hex,crop,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"