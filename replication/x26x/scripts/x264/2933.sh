#!/bin/sh

numb='2934'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 0.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 25 --keyint 240 --lookahead-threads 1 --min-keyint 24 --qp 30 --qpstep 5 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset slower --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.4,1.1,0.2,0.5,0.7,0.3,0,0,2,25,240,1,24,30,5,1,61,18,1,2000,-2:-2,hex,crop,slower,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"