#!/bin/sh

numb='753'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 0.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 10 --keyint 200 --lookahead-threads 1 --min-keyint 28 --qp 0 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.6,1.2,0.6,0.4,0.7,0.9,3,0,14,10,200,1,28,0,5,3,60,38,4,2000,1:1,umh,crop,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"