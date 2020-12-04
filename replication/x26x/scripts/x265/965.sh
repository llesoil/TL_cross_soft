#!/bin/sh

numb='966'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 45 --keyint 270 --lookahead-threads 3 --min-keyint 23 --qp 50 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.1,1.1,0.6,0.6,0.7,0.8,2,0,4,45,270,3,23,50,5,3,63,18,3,2000,1:1,dia,crop,slow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"