#!/bin/sh

numb='1108'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 15 --keyint 200 --lookahead-threads 2 --min-keyint 22 --qp 10 --qpstep 5 --qpmin 0 --qpmax 68 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.0,1.2,0.6,0.5,0.8,0.2,0,1,12,15,200,2,22,10,5,0,68,18,3,1000,-2:-2,dia,show,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"