#!/bin/sh

numb='802'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 4.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 30 --keyint 280 --lookahead-threads 3 --min-keyint 24 --qp 20 --qpstep 3 --qpmin 2 --qpmax 64 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.6,1.3,4.0,0.5,0.6,0.5,1,1,6,30,280,3,24,20,3,2,64,38,4,2000,-1:-1,umh,crop,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"