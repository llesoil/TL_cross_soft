#!/bin/sh

numb='317'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 2.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 20 --keyint 200 --lookahead-threads 1 --min-keyint 27 --qp 50 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset superfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.0,1.5,1.0,2.6,0.4,0.9,0.9,1,1,6,20,200,1,27,50,3,4,67,28,2,1000,-2:-2,dia,crop,superfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"