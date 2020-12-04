#!/bin/sh

numb='2184'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 3.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 10 --keyint 240 --lookahead-threads 4 --min-keyint 28 --qp 0 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset slower --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.0,1.0,1.2,3.0,0.3,0.9,0.9,0,0,6,10,240,4,28,0,5,0,63,48,6,1000,-2:-2,hex,crop,slower,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"