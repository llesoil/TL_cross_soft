#!/bin/sh

numb='2145'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 5.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 40 --keyint 270 --lookahead-threads 2 --min-keyint 30 --qp 0 --qpstep 4 --qpmin 1 --qpmax 63 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,3.0,1.5,1.2,5.0,0.6,0.7,0.4,0,0,4,40,270,2,30,0,4,1,63,28,6,1000,-2:-2,hex,crop,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"