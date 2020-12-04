#!/bin/sh

numb='2589'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 2.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 5 --keyint 290 --lookahead-threads 3 --min-keyint 23 --qp 30 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset slower --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.1,1.2,2.6,0.3,0.9,0.3,0,2,2,5,290,3,23,30,5,2,63,28,4,2000,1:1,umh,crop,slower,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"