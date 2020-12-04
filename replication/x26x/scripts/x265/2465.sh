#!/bin/sh

numb='2466'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 30 --keyint 270 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 3 --qpmax 68 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset slower --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,3.0,1.6,1.4,3.2,0.2,0.8,0.5,2,0,4,30,270,2,30,40,5,3,68,38,4,2000,-2:-2,umh,crop,slower,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"