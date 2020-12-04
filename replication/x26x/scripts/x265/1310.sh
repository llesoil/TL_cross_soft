#!/bin/sh

numb='1311'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 45 --keyint 290 --lookahead-threads 0 --min-keyint 22 --qp 0 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.0,1.0,1.1,3.6,0.4,0.8,0.6,0,0,8,45,290,0,22,0,5,2,65,18,5,2000,-2:-2,hex,crop,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"