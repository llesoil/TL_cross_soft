#!/bin/sh

numb='888'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 2.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 0 --keyint 210 --lookahead-threads 1 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.2,1.4,2.0,0.6,0.6,0.0,3,0,12,0,210,1,26,50,4,1,64,48,5,1000,-1:-1,hex,crop,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"