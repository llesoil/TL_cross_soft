#!/bin/sh

numb='2336'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 3.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 0 --keyint 240 --lookahead-threads 2 --min-keyint 27 --qp 30 --qpstep 5 --qpmin 0 --qpmax 60 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.0,1.4,1.3,3.6,0.4,0.9,0.2,0,2,14,0,240,2,27,30,5,0,60,28,6,1000,-2:-2,hex,crop,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"