#!/bin/sh

numb='1589'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 2.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 10 --keyint 230 --lookahead-threads 2 --min-keyint 26 --qp 40 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.5,1.0,1.4,2.0,0.3,0.7,0.0,3,0,12,10,230,2,26,40,5,4,68,18,1,1000,-2:-2,umh,crop,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"