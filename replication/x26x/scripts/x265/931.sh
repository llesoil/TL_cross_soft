#!/bin/sh

numb='932'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 4.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 30 --keyint 260 --lookahead-threads 2 --min-keyint 25 --qp 10 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.5,1.1,1.3,4.6,0.5,0.8,0.4,0,2,16,30,260,2,25,10,3,2,62,28,2,2000,-2:-2,umh,crop,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"