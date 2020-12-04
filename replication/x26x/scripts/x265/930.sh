#!/bin/sh

numb='931'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 3.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 25 --keyint 200 --lookahead-threads 2 --min-keyint 26 --qp 30 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.6,1.2,3.4,0.3,0.6,0.0,0,2,6,25,200,2,26,30,3,4,67,48,3,1000,-1:-1,hex,show,superfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"