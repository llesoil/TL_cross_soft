#!/bin/sh

numb='381'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 40 --keyint 280 --lookahead-threads 1 --min-keyint 29 --qp 40 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset veryslow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,1.5,1.6,1.1,3.0,0.5,0.7,0.6,3,1,8,40,280,1,29,40,3,4,62,48,4,2000,1:1,umh,crop,veryslow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"