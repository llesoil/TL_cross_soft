#!/bin/sh

numb='1039'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 2.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 30 --keyint 230 --lookahead-threads 0 --min-keyint 22 --qp 10 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.6,1.4,2.4,0.2,0.9,0.0,3,1,14,30,230,0,22,10,4,0,68,38,5,1000,-2:-2,dia,crop,ultrafast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"