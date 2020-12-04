#!/bin/sh

numb='2698'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 2.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 30 --keyint 260 --lookahead-threads 4 --min-keyint 22 --qp 20 --qpstep 5 --qpmin 0 --qpmax 60 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.4,1.3,2.0,0.6,0.6,0.4,3,0,14,30,260,4,22,20,5,0,60,38,5,2000,1:1,umh,crop,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"