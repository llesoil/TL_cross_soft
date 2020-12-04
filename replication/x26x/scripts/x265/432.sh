#!/bin/sh

numb='433'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 2.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 10 --keyint 250 --lookahead-threads 3 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 2 --qpmax 64 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.0,1.4,1.1,2.4,0.2,0.7,0.9,1,0,6,10,250,3,26,50,4,2,64,18,6,1000,1:1,dia,crop,superfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"