#!/bin/sh

numb='2387'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --intra-refresh --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 25 --keyint 250 --lookahead-threads 0 --min-keyint 23 --qp 30 --qpstep 3 --qpmin 2 --qpmax 64 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,None,--slow-firstpass,--weightb,1.5,1.1,1.4,1.4,0.4,0.6,0.4,0,2,10,25,250,0,23,30,3,2,64,18,1,2000,-2:-2,umh,crop,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"