#!/bin/sh

numb='1953'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 3.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 14 --crf 10 --keyint 250 --lookahead-threads 2 --min-keyint 29 --qp 10 --qpstep 4 --qpmin 3 --qpmax 60 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,3.0,1.0,1.3,3.0,0.4,0.8,0.6,1,0,14,10,250,2,29,10,4,3,60,38,2,2000,-1:-1,dia,crop,fast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"