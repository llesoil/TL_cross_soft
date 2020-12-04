#!/bin/sh

numb='1563'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 45 --keyint 270 --lookahead-threads 0 --min-keyint 25 --qp 0 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.5,1.6,1.3,2.0,0.2,0.6,0.7,3,1,10,45,270,0,25,0,4,3,67,18,6,2000,-1:-1,hex,show,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"