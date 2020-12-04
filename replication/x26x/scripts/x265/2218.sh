#!/bin/sh

numb='2219'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 40 --keyint 270 --lookahead-threads 0 --min-keyint 23 --qp 0 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.2,1.3,1.4,0.4,0.9,0.7,2,1,16,40,270,0,23,0,5,4,63,38,3,1000,-2:-2,umh,show,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"