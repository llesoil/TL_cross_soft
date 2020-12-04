#!/bin/sh

numb='2959'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 45 --keyint 280 --lookahead-threads 0 --min-keyint 26 --qp 40 --qpstep 3 --qpmin 1 --qpmax 66 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.5,1.1,1.2,3.8,0.3,0.8,0.5,3,2,14,45,280,0,26,40,3,1,66,48,3,2000,-2:-2,umh,crop,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"