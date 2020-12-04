#!/bin/sh

numb='141'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 0 --keyint 280 --lookahead-threads 3 --min-keyint 20 --qp 10 --qpstep 4 --qpmin 2 --qpmax 66 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.1,1.3,3.2,0.5,0.7,0.6,0,0,8,0,280,3,20,10,4,2,66,18,2,2000,1:1,umh,crop,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"