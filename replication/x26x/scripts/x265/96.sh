#!/bin/sh

numb='97'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 0.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 35 --keyint 270 --lookahead-threads 2 --min-keyint 29 --qp 20 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,0.0,1.1,1.0,0.4,0.4,0.7,0.5,3,2,10,35,270,2,29,20,5,3,64,48,2,1000,1:1,umh,crop,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"