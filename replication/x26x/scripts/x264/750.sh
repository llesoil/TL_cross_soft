#!/bin/sh

numb='751'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 5.0 --qblur 0.6 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 35 --keyint 280 --lookahead-threads 4 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset veryfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.5,1.3,1.4,5.0,0.6,0.8,0.7,1,2,2,35,280,4,30,30,5,2,67,18,1,1000,-2:-2,hex,crop,veryfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"