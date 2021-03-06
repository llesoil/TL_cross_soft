#!/bin/sh

numb='166'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 10 --keyint 270 --lookahead-threads 3 --min-keyint 27 --qp 30 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.0,1.0,1.1,3.2,0.2,0.9,0.5,3,1,8,10,270,3,27,30,4,0,66,48,5,1000,-1:-1,umh,show,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"