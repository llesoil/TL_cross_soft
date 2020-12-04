#!/bin/sh

numb='2780'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 2.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 20 --keyint 220 --lookahead-threads 0 --min-keyint 26 --qp 40 --qpstep 5 --qpmin 3 --qpmax 65 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.0,1.1,1.0,2.6,0.6,0.7,0.3,1,2,2,20,220,0,26,40,5,3,65,18,1,2000,-1:-1,umh,crop,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"