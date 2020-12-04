#!/bin/sh

numb='864'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 0 --keyint 200 --lookahead-threads 1 --min-keyint 27 --qp 30 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset medium --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.5,1.3,1.0,1.0,0.5,0.6,0.3,3,2,10,0,200,1,27,30,3,1,67,18,2,2000,1:1,dia,crop,medium,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"