#!/bin/sh

numb='162'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 30 --keyint 200 --lookahead-threads 1 --min-keyint 29 --qp 50 --qpstep 4 --qpmin 3 --qpmax 62 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.5,1.0,4.0,0.4,0.7,0.5,0,1,0,30,200,1,29,50,4,3,62,28,4,1000,-2:-2,hex,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"