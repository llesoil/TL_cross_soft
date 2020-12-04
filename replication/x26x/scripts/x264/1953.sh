#!/bin/sh

numb='1954'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 15 --keyint 240 --lookahead-threads 1 --min-keyint 22 --qp 30 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.3,1.0,4.2,0.4,0.6,0.2,1,2,8,15,240,1,22,30,4,0,65,28,3,2000,1:1,dia,crop,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"