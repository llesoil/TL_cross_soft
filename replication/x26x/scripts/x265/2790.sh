#!/bin/sh

numb='2791'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 2.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.8 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 20 --keyint 260 --lookahead-threads 2 --min-keyint 28 --qp 0 --qpstep 3 --qpmin 1 --qpmax 62 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.2,1.1,2.2,0.3,0.8,0.8,3,2,0,20,260,2,28,0,3,1,62,38,1,2000,1:1,umh,crop,fast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"