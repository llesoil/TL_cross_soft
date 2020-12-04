#!/bin/sh

numb='2699'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 35 --keyint 300 --lookahead-threads 2 --min-keyint 26 --qp 0 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.3,1.0,4.8,0.2,0.9,0.5,3,1,10,35,300,2,26,0,5,2,63,28,6,2000,1:1,umh,show,medium,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"