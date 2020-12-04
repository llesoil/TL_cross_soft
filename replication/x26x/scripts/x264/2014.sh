#!/bin/sh

numb='2015'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 0.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 0 --keyint 220 --lookahead-threads 2 --min-keyint 26 --qp 50 --qpstep 5 --qpmin 3 --qpmax 62 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.5,1.4,1.1,0.2,0.5,0.8,0.4,2,0,12,0,220,2,26,50,5,3,62,38,4,1000,-2:-2,hex,show,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"