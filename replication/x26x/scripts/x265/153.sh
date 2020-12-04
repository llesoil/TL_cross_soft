#!/bin/sh

numb='154'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 5 --keyint 270 --lookahead-threads 3 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.0,1.0,1.4,4.8,0.3,0.8,0.6,2,1,14,5,270,3,28,10,5,4,66,18,2,1000,-1:-1,umh,crop,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"