#!/bin/sh

numb='1518'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 0 --keyint 220 --lookahead-threads 0 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryslow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.6,1.2,2.2,0.6,0.7,0.2,3,2,0,0,220,0,28,10,5,3,66,18,5,1000,-1:-1,umh,show,veryslow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"