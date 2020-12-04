#!/bin/sh

numb='2592'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 3.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 50 --keyint 250 --lookahead-threads 0 --min-keyint 27 --qp 50 --qpstep 3 --qpmin 1 --qpmax 66 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset superfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.2,1.1,3.0,0.4,0.7,0.8,1,1,12,50,250,0,27,50,3,1,66,18,5,2000,-1:-1,hex,crop,superfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"