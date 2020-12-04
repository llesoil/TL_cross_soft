#!/bin/sh

numb='889'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 15 --keyint 200 --lookahead-threads 4 --min-keyint 22 --qp 10 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.0,1.2,1.3,1.6,0.2,0.8,0.8,3,1,14,15,200,4,22,10,3,0,64,18,5,2000,-1:-1,dia,crop,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"