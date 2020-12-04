#!/bin/sh

numb='306'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 5.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 5 --keyint 200 --lookahead-threads 4 --min-keyint 25 --qp 20 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.5,1.6,1.1,5.0,0.3,0.8,0.6,2,1,10,5,200,4,25,20,4,1,67,18,2,2000,-2:-2,dia,crop,medium,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"