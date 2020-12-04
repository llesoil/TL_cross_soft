#!/bin/sh

numb='2942'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 0.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 15 --keyint 250 --lookahead-threads 3 --min-keyint 28 --qp 50 --qpstep 3 --qpmin 0 --qpmax 60 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.0,1.0,1.3,0.4,0.2,0.7,0.0,3,2,14,15,250,3,28,50,3,0,60,28,2,1000,-1:-1,umh,crop,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"