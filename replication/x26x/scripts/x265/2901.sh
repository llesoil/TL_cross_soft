#!/bin/sh

numb='2902'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 4.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 15 --keyint 250 --lookahead-threads 2 --min-keyint 25 --qp 10 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,2.0,1.2,1.1,4.0,0.4,0.6,0.7,2,2,0,15,250,2,25,10,3,3,62,48,4,1000,-2:-2,dia,show,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"