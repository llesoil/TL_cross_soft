#!/bin/sh

numb='1468'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 2.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 0 --keyint 300 --lookahead-threads 2 --min-keyint 28 --qp 40 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.0,1.6,1.4,2.6,0.6,0.9,0.4,2,1,4,0,300,2,28,40,4,1,64,38,2,2000,-1:-1,dia,show,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"