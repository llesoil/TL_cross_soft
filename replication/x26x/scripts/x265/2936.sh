#!/bin/sh

numb='2937'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --intra-refresh --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.9 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 45 --keyint 270 --lookahead-threads 0 --min-keyint 22 --qp 10 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,--no-asm,--slow-firstpass,--weightb,0.5,1.2,1.4,0.8,0.6,0.6,0.9,2,0,12,45,270,0,22,10,5,4,64,18,1,1000,-1:-1,dia,crop,ultrafast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"