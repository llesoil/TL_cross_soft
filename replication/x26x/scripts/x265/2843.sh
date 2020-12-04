#!/bin/sh

numb='2844'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 20 --keyint 270 --lookahead-threads 4 --min-keyint 21 --qp 20 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,3.0,1.2,1.1,0.6,0.2,0.9,0.5,0,2,2,20,270,4,21,20,3,4,65,28,5,1000,-2:-2,hex,crop,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"