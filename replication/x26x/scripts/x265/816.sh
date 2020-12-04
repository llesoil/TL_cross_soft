#!/bin/sh

numb='817'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 30 --keyint 290 --lookahead-threads 0 --min-keyint 24 --qp 40 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.6,1.0,4.0,0.2,0.6,0.4,1,2,0,30,290,0,24,40,5,4,63,18,4,2000,-1:-1,umh,crop,superfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"