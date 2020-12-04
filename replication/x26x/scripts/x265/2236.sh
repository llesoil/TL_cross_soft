#!/bin/sh

numb='2237'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 3.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 10 --keyint 240 --lookahead-threads 2 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.2,1.1,3.6,0.4,0.6,0.0,0,1,0,10,240,2,30,50,3,4,61,38,2,2000,1:1,umh,show,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"