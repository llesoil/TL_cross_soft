#!/bin/sh

numb='883'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 2.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 30 --keyint 240 --lookahead-threads 4 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset faster --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.0,1.1,1.4,2.8,0.3,0.9,0.7,1,1,4,30,240,4,24,40,3,1,68,28,5,2000,-2:-2,dia,crop,faster,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"