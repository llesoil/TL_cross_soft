#!/bin/sh

numb='157'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 25 --keyint 280 --lookahead-threads 1 --min-keyint 29 --qp 50 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset placebo --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.0,1.2,4.6,0.3,0.7,0.5,3,2,0,25,280,1,29,50,5,1,69,48,4,1000,-1:-1,dia,crop,placebo,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"