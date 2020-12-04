#!/bin/sh

numb='1152'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 3.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 40 --keyint 200 --lookahead-threads 3 --min-keyint 23 --qp 40 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.5,1.2,1.3,3.0,0.2,0.6,0.7,3,1,14,40,200,3,23,40,3,4,62,28,6,1000,-2:-2,hex,show,medium,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"