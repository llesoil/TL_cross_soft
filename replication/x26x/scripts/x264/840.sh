#!/bin/sh

numb='841'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 2.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 40 --keyint 240 --lookahead-threads 4 --min-keyint 30 --qp 20 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.5,1.2,1.3,2.0,0.2,0.8,0.3,0,1,8,40,240,4,30,20,5,4,62,38,6,2000,-2:-2,umh,show,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"