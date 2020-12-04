#!/bin/sh

numb='1189'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 35 --keyint 230 --lookahead-threads 3 --min-keyint 27 --qp 0 --qpstep 5 --qpmin 1 --qpmax 64 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.0,1.1,1.1,2.2,0.6,0.8,0.8,1,1,4,35,230,3,27,0,5,1,64,18,6,2000,-1:-1,umh,show,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"