#!/bin/sh

numb='789'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 1.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 0 --keyint 230 --lookahead-threads 4 --min-keyint 26 --qp 40 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.2,1.0,1.0,0.2,0.6,0.2,3,1,16,0,230,4,26,40,3,1,60,48,4,2000,-2:-2,hex,crop,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"