#!/bin/sh

numb='1943'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 2.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 0 --keyint 230 --lookahead-threads 1 --min-keyint 24 --qp 10 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset superfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.5,1.3,1.0,2.8,0.6,0.8,0.4,0,1,0,0,230,1,24,10,4,1,62,28,3,2000,1:1,dia,show,superfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"