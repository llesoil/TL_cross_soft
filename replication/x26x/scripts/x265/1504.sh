#!/bin/sh

numb='1505'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 5 --keyint 300 --lookahead-threads 2 --min-keyint 27 --qp 20 --qpstep 5 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.5,1.2,1.3,1.4,0.4,0.8,0.3,3,1,12,5,300,2,27,20,5,4,61,38,6,1000,-1:-1,dia,show,medium,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"