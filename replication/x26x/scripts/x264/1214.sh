#!/bin/sh

numb='1215'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 1.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 5 --keyint 260 --lookahead-threads 0 --min-keyint 26 --qp 50 --qpstep 3 --qpmin 1 --qpmax 61 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.4,1.3,1.6,0.3,0.6,0.0,1,2,2,5,260,0,26,50,3,1,61,48,1,1000,-2:-2,hex,show,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"