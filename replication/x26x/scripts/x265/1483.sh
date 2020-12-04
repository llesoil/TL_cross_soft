#!/bin/sh

numb='1484'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.2 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 10 --keyint 200 --lookahead-threads 4 --min-keyint 27 --qp 20 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.2,1.2,0.6,0.5,0.7,0.2,0,2,16,10,200,4,27,20,3,0,68,48,5,2000,-2:-2,umh,show,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"