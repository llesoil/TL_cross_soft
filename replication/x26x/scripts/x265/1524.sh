#!/bin/sh

numb='1525'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.5 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 0 --keyint 300 --lookahead-threads 1 --min-keyint 22 --qp 0 --qpstep 4 --qpmin 2 --qpmax 66 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.5,1.5,1.3,3.0,0.3,0.7,0.5,2,1,4,0,300,1,22,0,4,2,66,38,3,1000,-1:-1,hex,crop,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"