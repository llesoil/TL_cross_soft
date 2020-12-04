#!/bin/sh

numb='1394'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 35 --keyint 250 --lookahead-threads 3 --min-keyint 24 --qp 30 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.0,1.4,1.1,4.6,0.2,0.9,0.3,1,1,6,35,250,3,24,30,3,1,67,38,5,1000,-1:-1,umh,crop,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"