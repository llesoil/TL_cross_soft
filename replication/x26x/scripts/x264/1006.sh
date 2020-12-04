#!/bin/sh

numb='1007'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 3.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 5 --keyint 250 --lookahead-threads 2 --min-keyint 24 --qp 30 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.0,1.1,1.0,3.0,0.4,0.8,0.2,0,0,6,5,250,2,24,30,5,4,62,38,2,1000,-1:-1,umh,show,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"