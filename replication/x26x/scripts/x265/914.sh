#!/bin/sh

numb='915'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 0.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 20 --keyint 230 --lookahead-threads 0 --min-keyint 22 --qp 40 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset veryfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.5,1.2,1.3,0.6,0.4,0.6,0.9,0,2,10,20,230,0,22,40,5,3,63,38,4,1000,-2:-2,dia,crop,veryfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"