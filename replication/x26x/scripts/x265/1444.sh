#!/bin/sh

numb='1445'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 3.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 25 --keyint 240 --lookahead-threads 3 --min-keyint 26 --qp 30 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.1,1.0,3.4,0.6,0.8,0.6,0,0,10,25,240,3,26,30,3,4,61,38,3,2000,1:1,hex,show,slower,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"