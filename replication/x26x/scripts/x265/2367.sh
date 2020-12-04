#!/bin/sh

numb='2368'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 0.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 15 --keyint 210 --lookahead-threads 2 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset fast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.6,1.4,0.4,0.3,0.8,0.4,3,2,6,15,210,2,26,50,4,4,60,38,2,1000,1:1,hex,show,fast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"