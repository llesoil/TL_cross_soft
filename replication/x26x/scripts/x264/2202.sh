#!/bin/sh

numb='2203'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 2.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 15 --keyint 250 --lookahead-threads 3 --min-keyint 28 --qp 10 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.5,1.2,1.4,2.0,0.5,0.7,0.5,0,2,2,15,250,3,28,10,3,1,68,18,6,2000,1:1,hex,crop,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"