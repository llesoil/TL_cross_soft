#!/bin/sh

numb='2585'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 0.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 30 --keyint 300 --lookahead-threads 4 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.5,1.6,1.2,0.6,0.2,0.7,0.0,0,0,16,30,300,4,30,30,3,3,66,28,2,1000,1:1,umh,show,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"