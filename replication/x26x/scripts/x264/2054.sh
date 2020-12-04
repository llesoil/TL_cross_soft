#!/bin/sh

numb='2055'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 45 --keyint 280 --lookahead-threads 1 --min-keyint 26 --qp 10 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,3.0,1.5,1.3,1.8,0.5,0.6,0.4,0,0,16,45,280,1,26,10,5,0,66,38,6,2000,-1:-1,umh,show,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"