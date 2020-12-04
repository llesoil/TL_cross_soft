#!/bin/sh

numb='2771'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --intra-refresh --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 1.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 35 --keyint 280 --lookahead-threads 0 --min-keyint 25 --qp 40 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,None,None,--weightb,1.5,1.5,1.4,1.2,0.3,0.9,0.8,0,2,0,35,280,0,25,40,3,4,62,48,1,1000,-1:-1,umh,crop,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"