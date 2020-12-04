#!/bin/sh

numb='30'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 30 --keyint 200 --lookahead-threads 4 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.2,1.3,1.6,0.4,0.8,0.0,1,2,10,30,200,4,28,40,5,0,67,28,4,2000,1:1,umh,show,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"