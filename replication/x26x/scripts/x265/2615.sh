#!/bin/sh

numb='2616'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 1.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 15 --keyint 270 --lookahead-threads 0 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.0,1.3,1.1,1.2,0.5,0.8,0.2,2,1,2,15,270,0,28,20,5,2,63,38,6,1000,1:1,umh,show,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"