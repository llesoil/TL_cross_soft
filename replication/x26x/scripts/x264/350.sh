#!/bin/sh

numb='351'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 3.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 30 --keyint 280 --lookahead-threads 1 --min-keyint 21 --qp 30 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.0,1.5,1.4,3.8,0.2,0.6,0.1,2,1,12,30,280,1,21,30,3,0,64,48,1,2000,-1:-1,dia,crop,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"