#!/bin/sh

numb='3124'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.0 --qblur 0.5 --qcomp 0.9 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 30 --keyint 230 --lookahead-threads 0 --min-keyint 26 --qp 0 --qpstep 4 --qpmin 1 --qpmax 61 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset superfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.5,1.5,1.0,1.0,0.5,0.9,0.6,3,1,8,30,230,0,26,0,4,1,61,38,6,2000,-1:-1,umh,show,superfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"