#!/bin/sh

numb='118'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 3.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 16 --crf 35 --keyint 230 --lookahead-threads 2 --min-keyint 27 --qp 10 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,2.0,1.6,1.0,3.0,0.6,0.7,0.5,1,1,16,35,230,2,27,10,4,3,61,18,3,2000,1:1,umh,crop,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"