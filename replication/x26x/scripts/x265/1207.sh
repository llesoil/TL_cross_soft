#!/bin/sh

numb='1208'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 4.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 20 --keyint 290 --lookahead-threads 2 --min-keyint 29 --qp 10 --qpstep 4 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.2,1.3,4.2,0.2,0.8,0.2,1,1,2,20,290,2,29,10,4,4,68,28,4,2000,-2:-2,hex,crop,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"