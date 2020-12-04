#!/bin/sh

numb='463'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 4.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 15 --keyint 230 --lookahead-threads 0 --min-keyint 22 --qp 40 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.5,1.1,4.0,0.2,0.7,0.4,0,2,12,15,230,0,22,40,3,4,62,18,2,1000,-1:-1,dia,show,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"