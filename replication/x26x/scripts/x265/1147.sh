#!/bin/sh

numb='1148'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 1.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 15 --keyint 200 --lookahead-threads 1 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset medium --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.6,1.1,1.0,0.3,0.6,0.6,2,2,2,15,200,1,30,30,5,1,67,18,3,1000,-1:-1,dia,crop,medium,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"