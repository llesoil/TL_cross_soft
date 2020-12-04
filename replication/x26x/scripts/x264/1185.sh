#!/bin/sh

numb='1186'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 2.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 50 --keyint 230 --lookahead-threads 2 --min-keyint 23 --qp 50 --qpstep 5 --qpmin 2 --qpmax 66 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.5,1.5,1.2,2.2,0.6,0.7,0.1,3,0,10,50,230,2,23,50,5,2,66,18,3,1000,1:1,umh,show,slow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"