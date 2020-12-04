#!/bin/sh

numb='3075'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 2.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 0 --keyint 270 --lookahead-threads 4 --min-keyint 23 --qp 40 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.5,1.1,2.2,0.3,0.8,0.3,0,1,4,0,270,4,23,40,5,1,63,48,3,2000,1:1,umh,crop,fast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"