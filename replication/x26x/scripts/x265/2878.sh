#!/bin/sh

numb='2879'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 2.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 45 --keyint 220 --lookahead-threads 2 --min-keyint 30 --qp 30 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.2,1.0,2.8,0.2,0.8,0.1,2,0,12,45,220,2,30,30,4,3,69,18,1,2000,-1:-1,umh,crop,superfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"