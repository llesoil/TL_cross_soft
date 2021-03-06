#!/bin/sh

numb='496'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 4.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 50 --keyint 220 --lookahead-threads 0 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 1 --qpmax 66 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.2,1.3,4.2,0.2,0.6,0.3,1,1,10,50,220,0,28,10,5,1,66,48,2,1000,1:1,dia,crop,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"